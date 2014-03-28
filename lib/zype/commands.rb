require "thor"

require 'zype/auth'

require "zype/commands/configure"
require "zype/commands/data_source"
require "zype/commands/video"
require "zype/commands/zobject"
require "zype/commands/zobject_schema"

module Zype
  class Commands < Thor

    no_commands do
      def load_configuration
        Zype::Auth.load_configuration
      end
    end

  end
end