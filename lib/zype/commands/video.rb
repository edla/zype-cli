require "thor"

module Zype
  class Commands < Thor
    desc "video:list", "List Zype videos"

    method_option "filters", aliases: "f", type: :hash,    default: {}, desc: "Specify video filters"
    method_option "page",    aliases: "p", type: :numeric, default: 0,  desc: "Specify the page of videos to return"
    method_option "count",   aliases: "c", type: :numeric, default: 10, desc: "Specify the number of videos to return"      

    define_method "video:list" do
      load_configuration
      
      puts Zype::Client.new.videos.all(options[:filters], options[:page], options[:pagesize]).inspect
    end
  end
end