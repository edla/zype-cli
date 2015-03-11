require 'thor'

module Zype
  class Commands < Thor
    desc 'plan:list', 'List plans'

    method_option 'query', desc: 'Plan search terms',
                  aliases: 'q', type: :string
    method_option 'active', desc: 'Show active, inactive or all videos',
                  aliases: 'a', type: :string, default: 'true', enum: ['true','false','all']
    method_option 'page', desc: 'The page of plans to return',
                  aliases: 'p', type: :numeric, default: 0
    method_option 'per_page', desc: 'The number of plans to return',
                  aliases: 's', type: :numeric, default: 25

    define_method 'plan:list' do
      init_client

      plan = @zype.plans.all(
        :q => options[:query],
        :active => options[:active],
        :page => options[:page],
        :per_page => options[:per_page]
      )

      print_plans(plan)
    end

    no_commands do

      def print_plans(plans)
        puts Hirb::Helpers::Table.render(plans, :fields=>[:_id, :name, :description, :amount, :currency, :interval, :trial_period_days, :active])
      end
    end
  end
end
