require "thor"

module Zype
  class Commands < Thor
    desc "zobject-schema:list", "List Zobject schemas"

    method_option "filters", aliases: "f", type: :hash,    default: {}, desc: "Zobject schema query filters"
    method_option "page",    aliases: "p", type: :numeric, default: 0,  desc: "Page number to return"
    method_option "count",   aliases: "c", type: :numeric, default: 10, desc: "Number of results to return"

    define_method "zobject_schema:list" do
      load_configuration

      zobject_schemas = Zype::Client.new.zobject_schemas.all(options[:filters], options[:page], options[:pagesize])

      puts "Found #{zobject_schemas.size} zobject schemas(s)"
      puts "---"

      zobject_schemas.each do |zobject_schema|
        puts "Title: #{zobject_schema.title} (ID: #{zobject_schema._id})"
        puts "Attributes:"
          zobject_schema.keys.sort.each do |key|
          puts "  #{key}: #{zobject_schema[key]}"
        end
        puts "---"
      end
    end

    desc "zobject-schema:create", "Create Zobject schemas"

    method_option "attributes", aliases: "a", type: :hash, required: true, desc: "Specify schema attributes"

    define_method "zobject_schema:create" do
      load_configuration

      puts Zype::Client.new.zobject_schemas.create(options[:attributes])
    end
  end
end
