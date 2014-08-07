require 'hirb'
require "thor"
require 'zype/auth'
require "zype/commands/account"
require "zype/commands/playlist"
require "zype/commands/video"
require "zype/commands/zobject"
require "zype/commands/zobject_schema"
require "zype/progress_bar"

module Zype
  class Commands < Thor
    extend Hirb::Console

    no_commands do
      def init_client
        Zype::Auth.load_configuration
        @zype = Zype::Client.new
      end
    end

  end
end
