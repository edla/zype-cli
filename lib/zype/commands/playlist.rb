require "thor"

module Zype
  class Commands < Thor
    desc "playlist:list", "List playlists"

    method_option "query", aliases: "q", type: :string, desc: "Playlist search terms"
    method_option "category", aliases: "c", type: :hash, desc: "Optional category filters"
    method_option "active", aliases: "a", type: :string, default: 'true', desc: "Show active (true), inactive (false) or all (all) playlists"
    method_option "page",    aliases: "p", type: :numeric, default: 0,  desc: "Page number to return"
    method_option "per_page",   aliases: "s", type: :numeric, default: 25, desc: "Number of results to return"

    define_method "playlist:list" do
      load_configuration

      playlists = Zype::Client.new.playlists.all(
        :q => options[:query],
        :category => options[:category],
        :active => options[:active],
        :page => options[:page],
        :per_page => options[:per_page]
      )

      print_playlists(playlists)
    end

    desc "playlist:videos", "List playlist videos"

    method_option "id", aliases: "i", type: :string, required: true, desc: "Playlist ID"
    method_option "page",    aliases: "p", type: :numeric, default: 0,  desc: "Page number to return"
    method_option "per_page",   aliases: "s", type: :numeric, default: 10, desc: "Number of results to return"

    define_method "playlist:videos" do
      load_configuration

      begin
        playlist = Zype::Client.new.playlists.find(options[:id])

        videos = playlist.videos(
          :page => options[:page],
          :per_page => options[:per_page]
        )

        print_videos(videos)
      rescue Zype::Client::NotFound => e
        puts "Could not find playlist: #{options[:id]}"
      end
    end

    no_commands do

      def print_playlists(playlists)
        puts Hirb::Helpers::Table.render(playlists, :fields=>[:_id, :title, :description, :active])
      end

      def print_videos(videos)
        puts Hirb::Helpers::Table.render(videos, :fields=>[:_id, :title, :description, :duration, :status, :active])
      end
    end
  end
end
