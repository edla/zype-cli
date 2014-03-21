module ZypeCli
  class ZobjectSchemas < ZypeCli::Collection
    model Zobject
        
    def all(filters={})
      load(service.get('/zobject_schemas', filters: filters))
    end
    
    def find(id)
      load(service.get("/zobject_schemas/#{id}"))
    end
  end
end