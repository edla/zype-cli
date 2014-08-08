require 'zype'
require 'zype/commands'

module Zype
  class CLI
    def self.start
      Zype::Commands.start
    rescue Zype::Client::NoApiKey => e
      puts "#{e.class}: #{e.message}. Please run 'zype account:login' to configure your credentials"
    rescue Exception => e
      puts "#{e.class}: #{e.message}"
    end

    def self.configure
      Zype::Auth.credentials
    end
  end
end
