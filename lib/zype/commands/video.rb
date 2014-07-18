require 'thor'
require 'zype/progress_bar'
require 'zype/file_reader'
require 'zype/multipart'

module Zype
  class Commands < Thor
    desc "video:list", "List videos"

    method_option "filters", aliases: "f", type: :hash,    default: {}, desc: "Specify video filters"
    method_option "page",    aliases: "p", type: :numeric, default: 0,  desc: "Specify the page of videos to return"
    method_option "count",   aliases: "c", type: :numeric, default: 10, desc: "Specify the number of videos to return"

    define_method "video:list" do
      load_configuration

      videos = Zype::Client.new.videos.all(options[:filters], options[:page], options[:count])

      puts "Found #{videos.size} video(s)"
      puts "---"

      videos.each do |video|
        print_video(video)
      end
    end

    desc "video:update", "Update a video"

    method_option "id", aliases: "i", type: :string, required: true, desc: "The video to update"

    method_option "title", aliases: "t", type: :string, desc: "New video title"
    method_option "keywords", aliases: "k", type: :array, desc: "New video keywords"

    define_method "video:update" do
      load_configuration

      if video = Zype::Client.new.videos.find(options[:id])
        video.title = options[:title] if options[:title]
        video.keywords = options[:keywords] if options[:keywords]
        video.save
        print_video(video)
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
      load_configuration

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

      def print_video(video)
        puts "Title: #{video.title} (ID: #{video._id})"
        puts "Attributes:"
        video.keys.sort.each do |key|
          puts "  #{key}: #{video[key]}"
        end
        puts "---"
      end

      def upload_and_transcode_video(filename,options)
        upload = upload_video(filename)
        if upload.status == 'complete'
          #transcode_video(upload, title: options[:title] || upload.filename, keywords: options[:keywords])
        end
      end

      def transcode_video(upload,options={})
        Zype::Client.new.videos.create(options.merge(upload_id: upload["_id"]))
      end

      def upload_video(filename)
        file = File.open(filename)
        basename = File.basename(filename)
        size = options[:chunksize]  * 1024

        upload = Zype::Client.new.uploads.create(filename: basename, filesize: file.size)

        begin
          multipart = Zype::Multipart.new(upload, file)
          multipart.process

          upload.progress = 100
          upload.status = 'complete'


        rescue Interrupt => e
          puts "Upload Cancelled"
          upload.status = 'cancelled'
        rescue Exception => e
          puts "Error: ##{e.message}"
          upload.status = 'error'
          upload.message = "Error: ##{e.message}"
        ensure
          upload.save
        end
        puts ""
        upload
      end

    end

  end
end
