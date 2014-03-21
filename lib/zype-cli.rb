require 'hashie'
require 'multi_json'

require File.join(File.dirname(__FILE__), 'zype-cli', 'client')
require File.join(File.dirname(__FILE__), 'zype-cli', 'collection')
require File.join(File.dirname(__FILE__), 'zype-cli', 'configuration')
require File.join(File.dirname(__FILE__), 'zype-cli', 'model')

module ZypeCli

  class << self
    
    # The configuration object.
    # @see ZypeCli.configure
    def configuration
      @configuration ||= Configuration.new
    end
  
    # Call this method to modify defaults in your initializers.
    #
    # @example
    #   Airbrake.configure do |config|
    #     config.api_key = '1234567890abcdef'
    #     config.secure  = false
    #   end
    def configure
      yield(configuration)
    end
    
  end
end