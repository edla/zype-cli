require 'thor'

module Zype
  class Commands < Thor
    desc 'device:list', 'List devices'

    method_option 'query', desc: 'Device search terms',
                  aliases: 'q', type: :string
    method_option 'page', desc: 'The page of devices to return',
                  aliases: 'p', type: :numeric, default: 0
    method_option 'per_page', desc: 'The number of devices to return',
                  aliases: 's', type: :numeric, default: 25

    define_method 'device:list' do
      init_client

      devices = @zype.devices.all(
        :q => options[:query],
        :page => options[:page],
        :per_page => options[:per_page]
      )

      print_devices(devices)
    end

    desc 'device:find', 'Find a device by ID'

    method_option 'id', desc: 'Device ID',
                  aliases: 'i', type: :string, required: true

    define_method 'device:find' do
      init_client

      begin
        device = @zype.devices.find(options[:id])

        print_devices(device)

      rescue Zype::Client::NotFound => e
        puts "Could not find device: #{options[:id]}"
      end
    end

    no_commands do

      def print_devices(devices)
        puts Hirb::Helpers::Table.render(devices, :fields=>[:_id, :name, :description])
      end
    end
  end
end
