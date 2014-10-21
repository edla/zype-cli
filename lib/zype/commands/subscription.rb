require 'thor'

module Zype
  class Commands < Thor
    desc 'subscription:list', 'List subscriptions'

    method_option 'query', desc: 'Subscription search terms',
                  aliases: 'q', type: :string
    method_option 'active', desc: 'Show active, inactive or all videos',
                  aliases: 'a', type: :string, default: 'true', enum: ['true','false','all']                  
    method_option 'page', desc: 'The page of subscriptions to return',
                  aliases: 'p', type: :numeric, default: 0
    method_option 'per_page', desc: 'The number of subscriptions to return',
                  aliases: 's', type: :numeric, default: 25

    define_method 'subscription:list' do
      init_client

      subscription = @zype.subscriptions.all(
        :q => options[:query],
        :active => options[:active],
        :page => options[:page],
        :per_page => options[:per_page]
      )

      print_subscriptions(subscription)
    end

    desc 'subscription:create', 'Create subscriptions'

    method_option 'customer_id', aliases: 'c', type: :string, desc: 'Customer ID'
    method_option 'plan_id', aliases: 'p', type: :string, desc: 'Plan ID'
    
    define_method 'subscription:create' do
      init_client

      subscription = Zype::Client.new.subscriptions.create(
        plan_id: options[:plan_id],
        customer_id: options[:customer_id]
      )

      print_subscriptions([subscription])
    end

    no_commands do

      def print_subscriptions(subscriptions)
        # binding.pry
        puts Hirb::Helpers::Table.render(subscriptions, :fields=>[:_id, :plan_id, :customer_id, :amount, :currency, :interval, :trial_period_days, :active])
      end
    end
  end
end
