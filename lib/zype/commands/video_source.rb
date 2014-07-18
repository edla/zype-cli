require "thor"

module Zype
  class Commands < Thor
    desc "video-source:list", "List video sources"

    method_option "filters", aliases: "f", type: :hash,    default: {}, desc: "Video source query filters"
    method_option "page",    aliases: "p", type: :numeric, default: 0,  desc: "Page number to return"
    method_option "count",   aliases: "c", type: :numeric, default: 10, desc: "Number of results to return"

    define_method "video_source:list" do
      load_configuration

      video_sources = Zype::Client.new.video_sources.all(options[:filters], options[:page], options[:pagesize])

      puts "Found #{video_sources.size} video source(s)"
      puts "---"

      video_sources.each do |video_source|
        puts "Title: #{video_source.title} (ID: #{video_source.id})"
        puts "Attributes:"
          video_source.keys.sort.each do |key|
          puts "  #{key}: #{video_source[key]}"
        end
        puts "---"
      end
    end

    desc "video-source:create", "Create a video source"

    method_option "attributes", aliases: "a", type: :hash, required: true, desc: "Specify video source attributes"

    define_method "video_source:create" do
      load_configuration

      puts Zype::Client.new.video_sources.create(options[:attributes])
    end

    desc "video-source:destroy", "Destroy a video source"

    method_option "id", aliases: "i", type: :numeric, required: true, desc: "Video source ID"

    define_method "video_source:destroy" do
      load_configuration

      puts Zype::Client.new.video_sources.find(options[:id]).destroy
    end
  end
end
