require "thor"

module Zype
  class Commands < Thor
    desc "data-source:list", "List data sources"

    method_option "filters", aliases: "f", type: :hash,    default: {}, desc: "Data source query filters"  
    method_option "page",    aliases: "p", type: :numeric, default: 0,  desc: "Page number to return"
    method_option "count",   aliases: "c", type: :numeric, default: 10, desc: "Number of results to return"      

    define_method "data_source:list" do
      load_configuration
      
      data_sources = Zype::Client.new.data_sources.all(options[:filters], options[:page], options[:pagesize])
      
      puts "Found #{data_sources.size} data source(s)"
      puts "---"
      
      data_sources.each do |data_source|
        puts "Title: #{data_source.title} (ID: #{data_source.id})"
        puts "Attributes:"
          data_source.keys.sort.each do |key|
          puts "  #{key}: #{data_source[key]}"
        end
        puts "---"
      end
    end  
  
    desc "data-source:create", "Create data source"
  
    method_option "attributes", aliases: "a", type: :hash, required: true, desc: "Specify data source attributes"
  
    define_method "data_source:create" do
      load_configuration
      
      puts Zype::Client.new.data_sources.create(options[:attributes])
    end
    
    desc "data-source:destroy", "Destroy data source"
  
    method_option "id", aliases: "i", type: :numeric, required: true, desc: "Data source ID"
  
    define_method "data_source:destroy" do
      load_configuration
      
      puts Zype::Client.new.data_sources.find(options[:id]).destroy
    end
  end
end