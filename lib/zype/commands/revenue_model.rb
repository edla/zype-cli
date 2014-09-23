require 'thor'

module Zype
  class Commands < Thor
    desc 'revenue-model:list', 'List revenue models'

    method_option 'query', desc: 'Revenue model search terms',
                  aliases: 'q', type: :string
    method_option 'page', desc: 'The page of revenue models to return',
                  aliases: 'p', type: :numeric, default: 0
    method_option 'per_page', desc: 'The number of revenue models to return',
                  aliases: 's', type: :numeric, default: 25

    define_method 'revenue_model:list' do
      init_client

      revenue_models = @zype.revenue_models.all(
        :q => options[:query],
        :page => options[:page],
        :per_page => options[:per_page]
      )

      print_revenue_models(revenue_models)
    end

    desc 'revenue-model:find', 'Find a revenue model by ID'

    method_option 'id', desc: 'Revenue model ID',
                  aliases: 'i', type: :string, required: true

    define_method 'revenue_model:find' do
      init_client

      begin
        revenue_model = @zype.revenue_models.find(options[:id])

        print_revenue_models(revenue_model)

      rescue Zype::Client::NotFound => e
        puts "Could not find revenue model: #{options[:id]}"
      end
    end

    no_commands do

      def print_revenue_models(revenue_models)
        puts Hirb::Helpers::Table.render(revenue_models, :fields=>[:_id, :name, :description])
      end
    end
  end
end
