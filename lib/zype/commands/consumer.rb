require 'thor'

module Zype
  class Commands < Thor
    desc 'consumer:list', 'List Consumers'

    method_option 'query', desc: 'consumer search terms',
                  aliases: 'q', type: :string
    method_option 'page', desc: 'The page of consumers to return',
                  aliases: 'p', type: :numeric, default: 0
    method_option 'per_page', desc: 'The number of consumers to return',
                  aliases: 's', type: :numeric, default: 25

    define_method 'consumer:list' do
      init_client

      consumer = @zype.consumers.all(
        :q => options[:query],
        :active => options[:active],
        :page => options[:page],
        :per_page => options[:per_page]
      )

      print_consumers(consumer)
    end

    desc 'consumer:create', 'Create Consumers'

    method_option 'email', aliases: 'e', type: :string, desc: 'consumer email'

    define_method 'consumer:create' do
      init_client

      consumer = Zype::Client.new.consumers.create(
        email: options[:email]
      )

      print_consumers([consumer])
    end

    desc 'consumer:favorite_videos', "List a Consumer's Favorite Videos"

    method_option 'consumer_id', aliases: 'i', type: :string, required: true, desc: 'Consumer ID'

    define_method 'consumer:favorite_videos' do
      init_client

      consumer = @zype.consumers.find(options[:consumer_id])

      print_video_favorites(consumer['video_favorites'])
    end

    desc 'consumer:favorite_video', 'Consumer Favorite Video'

    method_option 'consumer_id', aliases: 'i', type: :string, required: true, desc: 'Consumer ID'
    method_option 'video_id', aliases: 'v', type: :string, required: true, desc: 'Video ID'

    define_method 'consumer:favorite_video' do
      init_client

      consumer = @zype.consumers.find(options[:consumer_id])
      consumer.favorite_video(options[:video_id])

      print_consumers([consumer])
    end

    desc 'consumer:unfavorite_video', 'Consumer Unfavorites a video'

    method_option 'consumer_id', aliases: 'i', type: :string, required: true, desc: 'Consumer ID'
    method_option 'video_id', aliases: 'v', type: :string, required: true, desc: 'Video ID'

    define_method 'consumer:unfavorite_video' do
      init_client

      consumer = @zype.consumers.find(options[:consumer_id])
      consumer.unfavorite_video(options[:video_id])

      print_consumers([consumer])
    end

    desc 'consumer:rate_video', 'Consumer rates a video'

    method_option 'consumer_id', aliases: 'i', type: :string, required: true, desc: 'Consumer ID'
    method_option 'video_id', aliases: 'v', type: :string, required: true, desc: 'Video ID'
    method_option 'rating', aliases: 'r', type: :numeric, required: true, desc: 'Rating (0 to 5)'

    define_method 'consumer:rate_video' do
      init_client

      consumer = @zype.consumers.find(options[:consumer_id])
      consumer.rate_video(options[:video_id], rating: options[:rating])

      print_consumers([consumer])
    end

    no_commands do

      def print_consumers(consumers)
        puts Hirb::Helpers::Table.render(consumers, :fields=>[:_id, :email, :subscription_count, :card_count, :video_favorites, :created_at])
      end

      def print_video_favorites(video_favorites)
        puts Hirb::Helpers::Table.render(video_favorites, :fields => [:_id, :video_id, :created_at, :updated_at])
      end
    end
  end
end
