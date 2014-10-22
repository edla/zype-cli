require 'thor'

module Zype
  class Commands < Thor
    desc 'customer:list', 'List customers'

    method_option 'query', desc: 'Customer search terms',
                  aliases: 'q', type: :string
    method_option 'page', desc: 'The page of customers to return',
                  aliases: 'p', type: :numeric, default: 0
    method_option 'per_page', desc: 'The number of customers to return',
                  aliases: 's', type: :numeric, default: 25

    define_method 'customer:list' do
      init_client

      customer = @zype.customers.all(
        :q => options[:query],
        :active => options[:active],
        :page => options[:page],
        :per_page => options[:per_page]
      )

      print_customers(customer)
    end

    desc 'customer:create', 'Create Customers'

    method_option 'email', aliases: 'e', type: :string, desc: 'Customer email'

    define_method 'customer:create' do
      init_client

      customer = Zype::Client.new.customers.create(
        email: options[:email]
      )

      print_customers([customer])
    end

    desc 'customer:favorite_videos', 'List Favorite Videos'

    method_option 'customer_id', aliases: 'i', type: :string, required: true, desc: 'Customer ID'

    define_method 'customer:favorite_videos' do
      init_client

      customer = @zype.customers.find(options[:customer_id])

      print_video_favorites(customer['video_favorites'])
    end

    desc 'customer:favorite_video', 'Customer Favorites Video'

    method_option 'customer_id', aliases: 'i', type: :string, required: true, desc: 'Customer ID'
    method_option 'video_id', aliases: 'v', type: :string, required: true, desc: 'Video ID'

    define_method 'customer:favorite_video' do
      init_client

      customer = @zype.customers.find(options[:customer_id])
      customer.favorite_video(options[:video_id])

      puts 'video favorited :)'
    end

    desc 'customer:unfavorite_video', 'Customer Unfavorites a video'

    method_option 'customer_id', aliases: 'i', type: :string, required: true, desc: 'Customer ID'
    method_option 'video_id', aliases: 'v', type: :string, required: true, desc: 'Video ID'

    define_method 'customer:unfavorite_video' do
      init_client

      customer = @zype.customers.find(options[:customer_id])
      customer.unfavorite_video(options[:video_id])

      puts 'video unfavorited :('
    end

    no_commands do

      def print_customers(customers)
        puts Hirb::Helpers::Table.render(customers, :fields=>[:_id, :email, :subscription_count, :card_count, :video_favorites, :created_at])
      end

      def print_video_favorites(video_favorites)
        puts Hirb::Helpers::Table.render(video_favorites, :fields => [:_id, :video_id, :created_at, :updated_at])
      end
    end
  end
end
