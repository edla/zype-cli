require "thor"
require "yaml"

module Zype
  class Commands < Thor

    desc "account:logout", "Delete Zype configuration"
    define_method "account:logout" do
      Zype::Auth.delete_configuration
    end

    no_commands do
      def print_accounts(accounts)
        puts Hirb::Helpers::Table.render(accounts, :fields=>[:title, :description, :api_key, :player_key, :upload_key, :upload_secret])
      end
    end
  end
end
