require 'hirb'
require "thor"
require 'zype/auth'
require "zype/commands/account"
require "zype/commands/category"
require "zype/commands/device"
# require "zype/commands/device_category"
require "zype/commands/playlist"
require "zype/commands/video"
require "zype/commands/zobject"
require "zype/commands/zobject_type"
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
