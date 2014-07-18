require "thor"

module Zype
  class Commands < Thor
    desc "playlist:list", "List playlists"

    method_option "filters", aliases: "f", type: :hash,    default: {}, desc: "playlist query filters"
    method_option "page",    aliases: "p", type: :numeric, default: 0,  desc: "Page number to return"
    method_option "count",   aliases: "c", type: :numeric, default: 10, desc: "Number of results to return"

    define_method "playlist:list" do
      load_configuration

      playlists = Zype::Client.new.playlists.all(options[:filters], options[:page], options[:pagesize])

      puts "Found #{playlists.size} playlists(s)"
      puts "---"

      playlists.each do |playlist|
        puts "Title: #{playlist.title} (ID: #{playlist._id})"
        puts "Attributes:"
          playlist.keys.sort.each do |key|
          puts "  #{key}: #{playlist[key]}"
        end
        puts "---"
      end
    end

    desc "playlist:create", "Create playlist"

    method_option "attributes", aliases: "a", type: :hash, required: true, desc: "Specify playlist attributes"

    define_method "playlist:create" do
      load_configuration

      puts Zype::Client.new.playlists.create(options[:attributes])
    end

    desc "playlist:destroy", "Destroy playlist"

    method_option "id", aliases: "i", type: :string, required: true, desc: "Playlist ID"

    define_method "playlist:destroy" do
      load_configuration

      puts Zype::Client.new.playlists.find(options[:id]).destroy
    end

    desc "playlist:videos", "List playlist videos"

    method_option "id", aliases: "i", type: :string, required: true, desc: "Playlist ID"

    define_method "playlist:videos" do
      load_configuration

      playlist = Zype::Client.new.playlists.find(options[:id])
      videos = playlist.videos

      puts "Found #{videos.size} video(s)"
      puts "---"

      videos.each do |video|
        print_video(video)
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
    end
  end
end
