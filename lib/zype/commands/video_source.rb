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
  end
end
