require 'net/https'

module ZypeCli
  class Client

    class NoToken < StandardError; end

    class << self
      attr_writer :use_ssl, :api_key, :host, :port

      def use_ssl
        @use_ssl || false
      end
      
      def host
        @host || 'api.zype-core.com'
      end
      
      def port
        @port || 3000
      end
      
      def api_key
        @api_key
      end
      
      alias_method :old_new, :new

      def new(options={})
        setup_requirements
                
        old_new
      end

      def setup_requirements
        @required ||= false
        unless @required
          for model in models
            require [@model_path, model].join('/')
          end
          for collection in collections
            puts collection
            require [@model_path, collection].join('/')
            constant = collection.to_s.split('_').map {|characters| characters[0...1].upcase << characters[1..-1]}.join('')
            ZypeCli::Client.class_eval <<-EOS, __FILE__, __LINE__
              def #{collection}(attributes = {})
                ZypeCli::#{constant}.new({:service => self}.merge(attributes))
              end
            EOS
          end
          @required = true
        end
      end

      def collection(new_collection)
        collections << new_collection
      end

      def collections
        @collections ||= []
      end

      def model_path(new_path)
        @model_path = new_path
      end

      def model(new_model)
        models << new_model
      end

      def models
        @models ||= []
      end

      def request_path(new_path)
        @request_path = new_path
      end

      def request(new_request)
        requests << new_request
      end

      def requests
        @requests ||= []
      end
    end
    
    model_path 'zype-cli/models'
    
    model :zobject_schema
    model :zobject
    
    collection :zobject_schemas
    collection :zobjects
    
    def get(path,params={})
      raise NoToken if Client.api_key.to_s.empty?
      
      params.merge!('api_key' => Client.api_key)
      
      request = Net::HTTP::Get.new(path)
      request.body = MultiJson.encode(params)
      request["Content-Type"] = "application/json"

      http = Net::HTTP.new(Client.host, Client.port)
      http.use_ssl = Client.use_ssl

      response = http.start {|h| h.request(request)}

      if response.code == '200'
        handle_response(response)
      else
        
      end
    end
  
    def handle_response(response)
      if response.body.to_s.empty?
        {}    
      else
        MultiJson.decode(response.body)
      end
    end
  end
end
