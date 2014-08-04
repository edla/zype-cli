require "thor"
require 'zype/file_reader'

module Zype
  class Commands < Thor
    desc "zobject:list", "List Zobjects"

    method_option "schema",  aliases: "s", type: :string,  required: true, desc: "Zobject schema title"
    method_option "query", aliases: "q", type: :string, desc: "Playlist search terms"
    method_option "filters", aliases: "f", type: :hash,    default: {}, desc: "Zobject query filters"
    method_option "active", aliases: "a", type: :string, default: 'true', desc: "Show active (true), inactive (false) or all (all) zobjects"
    method_option "page",    aliases: "p", type: :numeric, default: 0,  desc: "Page number to return"
    method_option "per_page",   aliases: "s", type: :numeric, default: 25, desc: "Number of results to return"

    define_method "zobject:list" do
      load_configuration

      params = {
        :q => options[:query],
        :category => options[:category],
        :active => options[:active],
        :page => options[:page],
        :per_page => options[:per_page]
      }

      params.merge!(options[:filters])

      zobjects = Zype::Client.new.zobjects.all(options[:schema],params)

      print_zobjects(zobjects)
    end

    desc "zobject:import", "Import CSV of Zobject records"
    method_option "schema", aliases: "s", type: :string,  required: true, desc: "Zobject schema title"
    method_option "filename", aliases: "f", aliases: "f", type: :string, required: true, desc: "File path to upload"

    define_method "zobject:import" do
      load_configuration
      filename = options[:filename]
      records = Zype::Client.new.zobjects.import(options[:schema], filename)
      puts records.body
    end



    desc "zobject:create", "Create Zobjects"

    method_option "schema",     aliases: ["s"], type: :string, required: true, desc: "Specify zobject schema"
    method_option "attributes", aliases: ["a"], type: :hash, required: true, desc: "Specify schema attributes"
    method_option "pictures", aliases: ["p"], type: :hash, required: false, desc: "Specify pictures hash"

    define_method "zobject:create" do
      load_configuration

      zobject = Zype::Client.new.zobjects.create(options[:schema],options[:attributes], options[:pictures])

      print_zobjects([zobject])
    end

    no_commands do

      def print_zobjects(zobjects)
        puts Hirb::Helpers::Table.render(zobjects, :fields=>[:_id, :title, :description, :active])
      end
    end
  end
end
