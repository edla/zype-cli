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

    no_commands do

      def print_customers(customers)
        # binding.pry
        puts Hirb::Helpers::Table.render(customers, :fields=>[:_id, :email, :subscription_count, :card_count, :video_favorites, :created_at])
      end
    end
  end
end
