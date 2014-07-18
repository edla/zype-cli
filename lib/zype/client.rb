require 'net/https'

module Zype
  class Client

    class NoApiKey < StandardError; end
    class NotFound < StandardError; end
    class ServerError < StandardError; end
    class ImATeapot < StandardError; end
    class Unauthorized < StandardError; end
    class UnprocessableEntity < StandardError; end

    # for error types not explicity mapped
    class GenericError < StandardError; end

    ERROR_TYPES = {
      '401' => Unauthorized,
      '404' => NotFound,
      '418' => ImATeapot,
      '422' => UnprocessableEntity,
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
            Zype::Client.class_eval <<-EOS, __FILE__, __LINE__
              def #{collection}(attributes = {})
                Zype::#{constant}.new({:service => self}.merge(attributes))
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

    model_path 'zype/models'

    model :account
    model :upload
    model :video
    model :video_source
    model :zobject_schema
    model :zobject

    collection :uploads
    collection :videos
    collection :video_sources
    collection :zobject_schemas
    collection :zobjects

    def account
      Zype::Account.new(get('/account')['response'])
    end

    def get(path,params={})
      raise NoApiKey if Zype.configuration.api_key.to_s.empty?

      request = Net::HTTP::Get.new(path)
      request.body = MultiJson.encode(params)
      request["Content-Type"] = "application/json"
      request["x-zype-key"] = Zype.configuration.api_key

      http = Net::HTTP.new(Zype.configuration.host, Zype.configuration.port)
      http.use_ssl = Zype.configuration.use_ssl

      response = http.start {|h| h.request(request)}

      handle_response(response)
    end

    def post(path,params={})
      raise NoApiKey if Zype.configuration.api_key.to_s.empty?

      request = Net::HTTP::Post.new(path)
      request.body = MultiJson.encode(params)
      request["Content-Type"] = "application/json"
      request["x-zype-key"] = Zype.configuration.api_key

      http = Net::HTTP.new(Zype.configuration.host, Zype.configuration.port)
      http.use_ssl = Zype.configuration.use_ssl

      response = http.start {|h| h.request(request)}

      handle_response(response)
    end

    def put(path,params={})
      raise NoApiKey if Zype.configuration.api_key.to_s.empty?

      request = Net::HTTP::Put.new(path)
      request.body = MultiJson.encode(params)
      request["Content-Type"] = "application/json"
      request["x-zype-key"] = Zype.configuration.api_key

      http = Net::HTTP.new(Zype.configuration.host, Zype.configuration.port)
      http.use_ssl = Zype.configuration.use_ssl

      response = http.start {|h| h.request(request)}

      handle_response(response)
    end

    def delete(path,params={})
      raise NoApiKey if Zype.configuration.api_key.to_s.empty?

      request = Net::HTTP::Delete.new(path)
      request.body = MultiJson.encode(params)
      request["Content-Type"] = "application/json"
      request["x-zype-key"] = Zype.configuration.api_key

      http = Net::HTTP.new(Zype.configuration.host, Zype.configuration.port)
      http.use_ssl = Zype.configuration.use_ssl

      response = http.start {|h| h.request(request)}

      handle_response(response)
    end

    def handle_response(response)
      json = MultiJson.decode(response.body) if response.body

      case response.code
      when /2(\d{2})/
        success!(response.code,json)
      else
        error!(response.code,json)
      end
    end

    def success!(status, response)
      response
    end

    def error!(status,response)
      error_type = ERROR_TYPES[status] || GenericError
      raise error_type.new(response['message'])
    end
  end
end
