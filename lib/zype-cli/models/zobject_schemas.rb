module ZypeCli
  class ZobjectSchemas < ZypeCli::Collection
    model Zobject
        
    def all(filters={})
      load(service.get('/zobject_schemas', filters: filters))
    end
  end
end