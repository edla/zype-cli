module Zype
  class ZobjectTypes < Zype::Collection
    model ZobjectType

    def all(params={})
      load(service.get('/zobject_types', params))
    end

    def find(id)
      load(service.get("/zobject_types/#{id}"))
    end

    def create(attributes={})
      load(service.post("/zobject_types", zobject_type: attributes))
    end
  end
end
