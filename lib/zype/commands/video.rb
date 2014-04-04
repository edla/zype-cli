require "thor"
require 'progressbar'
require 'zype/file_reader'

module Zype
  class Commands < Thor
    desc "video:list", "List Zype videos"

    method_option "filters", aliases: "f", type: :hash,    default: {}, desc: "Specify video filters"
    method_option "page",    aliases: "p", type: :numeric, default: 0,  desc: "Specify the page of videos to return"
    method_option "count",   aliases: "c", type: :numeric, default: 10, desc: "Specify the number of videos to return"      

    define_method "video:list" do
      load_configuration
      
      puts Zype::Client.new.videos.all(options[:filters], options[:page], options[:pagesize]).inspect
    end
    
    desc "video:upload", "Uploads a video"
    
    method_option "filename", aliases: "f", type: :string, required: false, desc: "File path to upload"
    method_option "directory", aliases: "d", type: :string, required: false, desc: "Directory to upload"
    
    method_option "chunksize", aliases: "c", type: :numeric, default: 512, desc: "Chunk size (KB)"
    
    define_method "video:upload" do
      load_configuration
      
      chunksize = options[:chunksize]
      
      if filename = options[:filename]
        upload_file(filename,chunksize)
      end
      
      if directory = options[:directory]
        Dir.foreach(directory) do |filename|
          next if filename == '.' or filename == '..'

          upload_file(directory + "/" + filename,chunksize)
        end
      end
    end
  
    no_commands do
    
      def upload_file(filename,chunksize)
        file = File.open(filename)
        basename = File.basename(filename)
        size = chunksize * 1024
      
        upload = Zype::Client.new.uploads.create(filename: basename, filesize: file.size)
      
        uri = URI.parse(upload["upload_url"])
      
        pbar = Zype::ProgressBar.new(basename, file.size)
       
        last_check_in = Time.now
      
        chunked = Zype::FileReader.new(file, size) do |file_reader|

          pbar.set(file_reader.current)
          progress = (file_reader.current.to_f / file.size * 100).floor
        
          if  last_check_in < Time.now - 5 # seconds
            upload.progress = progress
            upload.status = 'uploading'
            upload.save
            last_check_in = Time.now
          end
        end
      
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        req = Net::HTTP::Put.new(uri.request_uri)
        req.body_stream  = chunked     
        req["Content-Type"] = "multipart/form-data"
        req.add_field('Content-Length', File.size(file))
                  
        res = http.request(req)

        upload.progress = 100
        upload.status = 'complete'
        upload.save
        
        puts ""
      end

    end  
  
  end
end