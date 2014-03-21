module ZypeCli
  class Collection
    attr_reader :service
    
    def self.model(new_model=nil)
      if new_model == nil
        @model
      else
        @model = new_model
      end
    end
    
    def initialize(attributes={})
      @service = attributes.delete(:service)
      
      merge_attributes!(attributes)
    end
    
    def model
      self.class.instance_variable_get('@model')
    end
    
    def load(attributes = {})
      case
      when attributes.is_a?(Hash)
        model.new({:service => service}.merge(attributes))
      when attributes.is_a?(Array)
        attributes.collect do |a|
          model.new({:service => service}.merge(a))
        end
      else
        raise(ArgumentError.new("Initialization parameters must be a Hash or Array, got #{attributes.class}"))
      end
    end
    
    def merge_attributes!(attributes = {})
      attributes.each_pair do |att, value|
        self.send("#{att}=", value) if self.respond_to?("#{att}=")
      end
      self
    end
  end
end