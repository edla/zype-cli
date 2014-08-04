module Zype
  class ZobjectSchemas < Zype::Collection
    model ZobjectSchema

    def all(params={})
      load(service.get('/zobject_schemas', params))
    end

    def find(id)
      load(service.get("/zobject_schemas/#{id}"))
    end

    def create(attributes={})
      load(service.post("/zobject_schemas", zobject_schema: attributes))
    end
  end
end
