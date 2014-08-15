require 'thor'

module Zype
  class Commands < Thor

    desc 'zobject-type:list', 'List Zobject types'

    method_option 'query', desc: 'Zobject type search terms',
                  aliases: 'q', type: :string
    method_option 'page', desc: 'The page of zobject types to return',
                  aliases: 'p', type: :numeric, default: 0
    method_option 'per_page', desc: 'The number of zobject types to return',
                  aliases: 's', type: :numeric, default: 25

    define_method 'zobject_type:list' do
      init_client

      zobject_types = Zype::Client.new.zobject_types.all(
        :q => options[:query],
        :page => options[:page],
        :per_page => options[:per_page]
      )

      print_zobject_types(zobject_types)
    end

    desc 'zobject-type:create', 'Create Zobject types'

    method_option 'attributes', aliases: 'a', type: :hash, required: true, desc: 'Zobject type attributes'

    define_method 'zobject_type:create' do
      init_client

      zobject_type = Zype::Client.new.zobject_types.create(options[:attributes])
      print_zobject_types([zobject_type])
    end

    no_commands do

      def print_zobject_types(zobject_types)
        puts Hirb::Helpers::Table.render(zobject_types, :fields=>[:_id, :title, :zobject_count, :videos_enabled])
      end
    end
  end
end
