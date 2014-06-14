module Zype
  class Zobjects < Zype::Collection
    model Zobject

    def all(zobject, filters={}, page=0, per_page=10, sort=nil, order=nil)
      load(service.get('/zobjects', zobject: zobject, filters: filters, page: page, per_page: per_page, sort: sort, order: order))
    end

    def find(zobject, id)
      load(service.get("/zobjects/#{id}", zobject: zobject))
    end

    def import(zobject, filename)
      load(service.post("/zobjects/import", zobject: zobject, filename: filename))
    end

    def create(zobject, attributes={})
      load(service.post("/zobjects", zobject: zobject, attributes: attributes))
    end

    def search(search_terms, zobject_schemas=[], page=0, per_page=10, sort=nil, order=nil)
       load(service.get('/zobjects/search', search_terms: search_terms, zobject_schemas: zobject_schemas, page: page, per_page: per_page, sort: sort, order: order))
    end
  end
end
