module ZypeCli
  class ZobjectSchemas < ZypeCli::Collection
    model Zobject

    def all(filters={}, page=0, pagesize=10)
      load(service.get('/zobject_schemas', filters: filters, page: page, pagesize: pagesize))
    end

    def find(id)
      load(service.get("/zobject_schemas/#{id}"))
    end
  end
end