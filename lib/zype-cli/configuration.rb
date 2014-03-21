module ZypeCli
  class Configuration
    attr_accessor :api_key
    attr_accessor :host    
    attr_accessor :port
    attr_accessor :use_ssl
    
    def initialize
      @host = 'api.zype-core.com'
      @port = 3000
      @use_ssl = false
    end
  end
end