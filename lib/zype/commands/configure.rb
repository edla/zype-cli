require "thor"
require "yaml"

module Zype
  class Commands < Thor
    desc "login", "Enter Zype configuration"
    define_method "login" do
      Zype::Auth.delete_configuration
      Zype::Auth.load_configuration      
    end  
    
    desc "logout", "Delete Zype configuration"
    define_method "logout" do
      Zype::Auth.delete_configuration
    end  
  end
end