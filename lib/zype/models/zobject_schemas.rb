module Zype
  class ZobjectSchemas < Zype::Collection
    model ZobjectSchema

    def all(filters={}, page=0, per_page=10)
      load(service.get('/zobject_schemas', filters: filters, page: page, per_page: per_page))
    end

    def find(id)
      load(service.get("/zobject_schemas/#{id}"))
    end
    
    def create(attributes={})
      load(service.post("/zobject_schemas", zobject_schema: attributes))
    end
  end
end