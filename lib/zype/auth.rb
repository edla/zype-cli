require 'pry-debugger'
module Zype
  class Auth
    extend Zype::Helpers

    class << self
      attr_accessor :configuration

      def configuration_path
        "#{home_directory}/.zype"
      end

      def load_configuration
        Zype.configuration = get_configuration
      end

      def get_configuration
        self.configuration = (read_configuration || ask_for_and_save_configuration)
      end

      def read_configuration
        if File.exists?(configuration_path)
          yaml = YAML.load_file(configuration_path)

          if configuration = Zype::Configuration.load_yaml(yaml)
            puts "Loaded: #{configuration_path}"
            configuration
          end
        end
      end

      def ask_for_and_save_configuration
        configuration = ask_for_configuration

        write_configuration(configuration)
      end

      def ask_for_configuration
        config = Configuration.new

        puts "Enter your Zype API key:"
        config.api_key = ask

        #puts "Enter your Zype API key (typing will be hidden):"
        #configuration.api_key = (running_on_windows? ? ask_silent_on_windows : ask_silent)

        config
      end

      def write_configuration(configuration)
        begin
          file = File.open(configuration_path, "w")
          file.write(configuration.to_yaml)
          puts "Saved: #{configuration_path}"
        rescue IOError => e
          #some error occur, dir not writable etc.
        ensure
          file.close unless file == nil
        end
      end

      def delete_configuration
        if File.exists?(configuration_path)
          File.delete(configuration_path)
          puts "Deleted: #{configuration_path}"
        end
      end
    end
  end
end