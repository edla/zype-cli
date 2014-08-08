require "thor"
require 'zype/progress_bar'
require 'zype/uploader'

module Zype
  class Commands < Thor
    desc "video:list", "List videos"

    method_option "query", aliases: "q", type: :string, desc: "Playlist search terms"
    method_option "category", aliases: "c", type: :hash, desc: "Optional category filters"
    method_option "active", aliases: "a", type: :string, default: 'true', desc: "Show active (true), inactive (false) or all (all) videos"
    method_option "page",    aliases: "p", type: :numeric, default: 0,  desc: "Page number to return"
    method_option "per_page",   aliases: "s", type: :numeric, default: 25, desc: "Number of results to return"

    define_method "video:list" do
      init_client

      videos = @zype.videos.all(
        :q => options[:query],
        :category => options[:category],
        :active => options[:active],
        :page => options[:page],
        :per_page => options[:per_page]
      )

      print_videos(videos)
    end

    desc "video:update", "Update a video"

    method_option "id", aliases: "i", type: :string, required: true, desc: "The video to update"
    method_option "active", aliases: "a", type: :boolean, desc: "New video status"
    method_option "featured", aliases: "f", type: :boolean, desc: "New featured status"
    method_option "title", aliases: "t", type: :string, desc: "New video title"
    method_option "description", aliases: "d", type: :string, desc: "New video description"
    method_option "keywords", aliases: "k", type: :array, desc: "New video keywords"

    define_method "video:update" do
      init_client

      if video = @zype.videos.find(options[:id])
        video.title = options[:title] unless options[:title].nil?
        video.keywords = options[:keywords] unless options[:keywords].nil?
        video.active = options[:active] unless options[:active].nil?
        video.featured = options[:featured] unless options[:featured].nil?
        video.description = options[:description] unless options[:description].nil?

        video.save
        print_videos([video])
      end
      puts ""
    end

    desc "video:upload", "Upload a video"

    method_option "title", aliases: "t", type: :string, required: false, desc: "New video title"
    method_option "keywords", aliases: "k", type: :array, desc: "New video keywords"

    method_option "filename", aliases: "f", type: :string, required: false, desc: "File path to upload"
    method_option "directory", aliases: "d", type: :string, required: false, desc: "Directory to upload"

    method_option "chunksize", aliases: "c", type: :numeric, default: 512, desc: "Chunk size (KB)"

    define_method "video:upload" do
      init_client

      filenames = []

      if filename = options[:filename]
        filenames << filename
      end

      if directory = options[:directory]
        directory = directory.chomp('/')
        filenames += Dir.glob(directory + "/*").reject{|f| f =~ /(^\.\.)|(^\.)/}
      end

      filenames.each do |filename|
        upload_and_transcode_video(filename, options)
      end
    end

    no_commands do

      def print_videos(videos)
        puts Hirb::Helpers::Table.render(videos, :fields=>[:_id, :title, :description, :duration, :status, :active])
      end

      def upload_and_transcode_video(filename,options)
        upload = upload_video(filename)
        if upload.status == 'complete'
          transcode_video(upload, title: options[:title] || upload.filename, keywords: options[:keywords])
        end
      end

      def transcode_video(upload,options={})
        @zype.videos.create(options.merge(upload_id: upload["_id"]))
      end

      def upload_video(filename)
        file = File.open(filename)
        basename = File.basename(filename)
        size = options[:chunksize]  * 1024

        upload = @zype.uploads.create(filename: basename, filesize: file.size)

        begin
          uploader = Zype::Uploader.new(@zype)
          uploader.process(upload,file)

          upload.progress = 100
          upload.status = 'complete'
        rescue Interrupt => e
          puts "Upload Cancelled"
          upload.status = 'cancelled'
        rescue Exception => e
          upload.status = 'error'
          upload.message = "Error: ##{e.message}"
          raise
        ensure
          upload.save
        end
        puts ""
        upload
      end
    end
  end
end
