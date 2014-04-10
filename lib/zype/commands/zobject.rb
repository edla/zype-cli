require "thor"
require 'zype/file_reader'

module Zype
  class Commands < Thor
    desc "zobject:list", "List Zobjects"

    method_option "schema",  aliases: "s", type: :string,  required: true, desc: "Zobject schema title"
    method_option "filters", aliases: "f", type: :hash,    default: {}, desc: "Zobject query filters"
    method_option "page",    aliases: "p", type: :numeric, default: 0,  desc: "Page number to return"
    method_option "count",   aliases: "c", type: :numeric, default: 10, desc: "Number of results to return"

    define_method "zobject:list" do
      load_configuration

      zobjects = Zype::Client.new.zobjects.all(options[:schema],options[:filters], options[:page], options[:pagesize])

      puts "Found #{zobjects.size} zobjects(s)"
      puts "---"

      zobjects.each do |zobject|
        puts "Title: #{zobject.title} (ID: #{zobject._id})"
        puts "Attributes:"
        zobject.keys.sort.each do |key|
          puts "  #{key}: #{zobject[key]}"
        end
        puts "---"
      end
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
    method_option "attributes", aliases: ["a"], type: :hash,   required: true, desc: "Specify schema attributes"

    define_method "zobject:create" do
      load_configuration

      Zype::Client.new.zobjects.create(options[:schema],options[:attributes]).inspect
    end
  end
end
