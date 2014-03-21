require 'net/https'

module ZypeCli
  class Client

    class NoApiKey < StandardError; end
    class NotFound < StandardError; end
    class ServerError < StandardError; end    
    class ImATeapot < StandardError; end
    class Unauthorized < StandardError; end
    
    ERROR_TYPES = {
      '401' => Unauthorized,
      '404' => NotFound,
      '418' => ImATeapot,
      '500' => ServerError
    }.freeze

    class << self
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
      raise NoApiKey if ZypeCli.configuration.api_key.to_s.empty?
      
      params.merge!('api_key' => ZypeCli.configuration.api_key)
      
      request = Net::HTTP::Get.new(path)
      request.body = MultiJson.encode(params)
      request["Content-Type"] = "application/json"

      http = Net::HTTP.new(ZypeCli.configuration.host, ZypeCli.configuration.port)
      http.use_ssl = ZypeCli.configuration.use_ssl

      response = http.start {|h| h.request(request)}

      handle_response(response)
    end
  
    def handle_response(response)
      json = MultiJson.decode(response.body)
    
      if response.code == '200'
        success!(response.code,json)
      else
        error!(response.code,json)
      end        
    end
  
    def success!(status, response)
      response
    end
    
    def error!(status,response)
      raise ERROR_TYPES[status].new(response['message'])
    end
  end
end
