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

    method_option 'consumer_id', aliases: 'c', type: :string, desc: 'consumer ID'
    method_option 'plan_id', aliases: 'p', type: :string, desc: 'Plan ID'

    define_method 'subscription:create' do
      init_client

      subscription = Zype::Client.new.subscriptions.create(
        plan_id: options[:plan_id],
        consumer_id: options[:consumer_id]
      )

      print_subscriptions([subscription])
    end

    desc 'subscription:delete', 'Delete subscription'

    method_option 'subscription_id', aliases: 'i', type: :string, required: true, desc: 'subscription ID'

    define_method 'subscription:delete' do
      init_client

      subscription = @zype.subscriptions.find(options[:subscription_id])

      subscription.destroy
    end

    desc 'subscription:update', 'Update subscription'

    method_option 'subscription_id', aliases: 'i', type: :string, required: true, desc: 'subscription ID'
    method_option 'plan_id', aliases: 'p', type: :string, desc: 'plan ID'

    define_method 'subscription:update' do
      init_client

      subscription = @zype.subscriptions.find(options[:subscription_id])

      subscription.plan_id = options[:plan_id] unless options[:plan_id].nil?
      subscription.save

      print_subscriptions([subscription])
    end

    no_commands do

      def print_subscriptions(subscriptions)
        puts Hirb::Helpers::Table.render(subscriptions, :fields=>[:_id, :plan_id, :consumer_id, :amount, :currency, :interval, :trial_period_days, :active])
      end
    end
  end
end
