require 'thor'

module Zype
  class Commands < Thor
    desc 'card:list', 'List cards'

    method_option 'customer_id', desc: 'Customer ID',
                  aliases: 'c', type: :string
    method_option 'page', desc: 'The page of cards to return',
                  aliases: 'p', type: :numeric, default: 0
    method_option 'per_page', desc: 'The number of cards to return',
                  aliases: 's', type: :numeric, default: 25

    define_method 'card:list' do
      init_client

      card = @zype.cards.all(options[:customer_id],
        :page => options[:page],
        :per_page => options[:per_page]
      )

      print_cards(card)
    end

    desc 'card:create', 'Create card'

    method_option 'customer_id', desc: 'Customer ID',
                  aliases: 'c', type: :string, required: true
    method_option 'token', desc: 'Credit card token',
                  aliases: 't', type: :string, required: true  
    
    define_method 'card:create' do
      init_client

      card = Zype::Client.new.cards.create(options[:customer_id],
        stripe_token: options[:token]
      )

      print_cards([card])
    end

    no_commands do

      def print_cards(cards)
        # binding.pry
        puts Hirb::Helpers::Table.render(cards, :fields=>[:_id, :brand, :last4, :country, :exp_month, :exp_year, :deleted])
      end
    end
  end
end
