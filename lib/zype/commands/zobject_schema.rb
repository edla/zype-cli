require 'thor'

module Zype
  class Commands < Thor

    desc 'zobject-schema:list', 'List Zobject schemas'

    method_option 'query', desc: 'Zobject schema search terms',
                  aliases: 'q', type: :string
    method_option 'page', desc: 'The page of zobject schemas to return',
                  aliases: 'p', type: :numeric, default: 0
    method_option 'per_page', desc: 'The number of zobject schemas to return',
                  aliases: 's', type: :numeric, default: 25

    define_method 'zobject_schema:list' do
      init_client

      zobject_schemas = Zype::Client.new.zobject_schemas.all(
        :q => options[:query],
        :page => options[:page],
        :per_page => options[:per_page]
      )

      print_zobject_schemas(zobject_schemas)
    end

    desc 'zobject-schema:create', 'Create Zobject schemas'

    method_option 'attributes', aliases: 'a', type: :hash, required: true, desc: 'Zobject schema attributes'

    define_method 'zobject_schema:create' do
      init_client

      zobject_schema = Zype::Client.new.zobject_schemas.create(options[:attributes])
      print_zobject_schemas([zobject_schema])
    end

    no_commands do

      def print_zobject_schemas(zobject_schemas)
        puts Hirb::Helpers::Table.render(zobject_schemas, :fields=>[:_id, :title, :zobject_count, :videos_enabled])
      end
    end
  end
end
