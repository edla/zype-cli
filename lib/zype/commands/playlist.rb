require 'thor'

module Zype
  class Commands < Thor
    desc 'playlist:list', 'List playlists'

    method_option 'query', desc: 'Playlist search terms',
                  aliases: 'q', type: :string
    method_option 'category', desc: 'Playlist category filters',
                  aliases: 'c', type: :hash
    method_option 'active', desc: 'Show active, inactive or all playlists',
                  aliases: 'a', type: :string, default: 'true', enum: ['true','false','all']
    method_option 'page', desc: 'The page of playlists to return',
                  aliases: 'p', type: :numeric, default: 0
    method_option 'per_page', desc: 'The number of playlists to return',
                  aliases: 's', type: :numeric, default: 25

    define_method 'playlist:list' do
      init_client

      playlists = @zype.playlists.all(
        :q => options[:query],
        :category => options[:category],
        :active => options[:active],
        :page => options[:page],
        :per_page => options[:per_page]
      )

      print_playlists(playlists)
    end

    desc 'playlist:videos', 'List playlist videos'

    method_option 'id', desc: 'Playlist ID',
                  aliases: 'i', type: :string, required: true
    method_option 'page', desc: 'The page of videos to return',
                  aliases: 'p', type: :numeric, default: 0
    method_option 'per_page', desc: 'The number of videos to return',
                  aliases: 's', type: :numeric, default: 10

    define_method 'playlist:videos' do
      init_client

      begin
        playlist = @zype.playlists.find(options[:id])

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
