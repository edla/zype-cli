require 'yaml'

module Zype
  class Configuration
    extend Zype::Helpers

    attr_accessor :api_key
    attr_accessor :host
    attr_accessor :port
    attr_accessor :use_ssl

    class << self

      def load_yaml(yaml)
        Zype::Configuration.new.tap do |c|
          c.api_key = yaml['api_key']
          c.host = yaml['host']
          c.port = yaml['port']
          c.use_ssl = yaml['use_ssl']
        end
      end

    end

    def initialize
      @host = 'api.zype.com'
      @port = 80
      @use_ssl = false
    end

    def to_yaml
      {
        'api_key' => api_key,
        'host' => host,
        'port' => port,
        'use_ssl' => use_ssl
      }.to_yaml
    end
  end
end
