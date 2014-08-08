require "thor"
require "yaml"

module Zype
  class Commands < Thor

    desc "account:login", "Enter credentials"
    define_method "account:login" do
      Zype::Auth.delete_configuration
      Zype::Auth.load_configuration
    end

    desc "account:logout", "Delete credentials"
    define_method "account:logout" do
      Zype::Auth.delete_configuration
    end

    desc "account:list", "Display account details"
    define_method "account:list" do
      init_client

      account = @zype.account

      print_accounts([account])
    end

    no_commands do
      def print_accounts(accounts)
        puts Hirb::Helpers::Table.render(accounts, :fields=>[:_id, :title, :domain, :description, :api_key, :player_key])
      end
    end
  end
end
