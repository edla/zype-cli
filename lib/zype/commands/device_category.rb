require 'thor'

module Zype
  class Commands < Thor
    desc 'device-category:list', 'List device categories'

    method_option 'query', desc: 'Device category search terms',
                  aliases: 'q', type: :string
    method_option 'page', desc: 'The page of device categories to return',
                  aliases: 'p', type: :numeric, default: 0
    method_option 'per_page', desc: 'The number of device categories to return',
                  aliases: 's', type: :numeric, default: 25

    define_method 'device_category:list' do
      init_client

      device_categories = @zype.device_categories.all(
        :q => options[:query],
        :page => options[:page],
        :per_page => options[:per_page]
      )

      print_device_categories(device_categories)
    end

    desc 'device-category:find', 'Find a device category by ID'

    method_option 'id', desc: 'Device category ID',
                  aliases: 'i', type: :string, required: true

    define_method 'device_category:find' do
      init_client

      begin
        device_category = @zype.device_categories.find(options[:id])

        print_device_categories(device_category)

      rescue Zype::Client::NotFound => e
        puts "Could not find device category: #{options[:id]}"
      end
    end

    no_commands do

      def print_device_categories(device_categories)
        puts Hirb::Helpers::Table.render(device_categories, :fields=>[:_id, :name])
      end
    end
  end
end
