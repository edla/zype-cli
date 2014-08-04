require "thor"

module Zype
  class Commands < Thor
    desc "zobject-schema:list", "List Zobject schemas"

    method_option "query", aliases: "q", type: :string, desc: "Playlist search terms"
    method_option "page",    aliases: "p", type: :numeric, default: 0,  desc: "Page number to return"
    method_option "per_page",   aliases: "s", type: :numeric, default: 25, desc: "Number of results to return"

    define_method "zobject_schema:list" do
      load_configuration

      zobject_schemas = Zype::Client.new.zobject_schemas.all(
        :q => options[:query],
        :page => options[:page],
        :per_page => options[:per_page]
      )

      print_zobject_schemas(zobject_schemas)
    end

    desc "zobject-schema:create", "Create Zobject schemas"

    method_option "attributes", aliases: "a", type: :hash, required: true, desc: "Specify schema attributes"

    define_method "zobject_schema:create" do
      load_configuration

      puts Zype::Client.new.zobject_schemas.create(options[:attributes])
    end

    no_commands do

      def print_zobject_schemas(zobject_schemas)
        puts Hirb::Helpers::Table.render(zobject_schemas, :fields=>[:_id, :title, :zobject_count, :videos_enabled])
      end
    end
  end
end
