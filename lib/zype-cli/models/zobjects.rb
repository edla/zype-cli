module ZypeCli
  class Zobjects < ZypeCli::Collection
    model Zobject

    def all(zobject, filters={}, page=0, pagesize=10)
      load(service.get('/zobjects', zobject: zobject, filters: filters, page: page, pagesize: pagesize))
    end

    def find(zobject, id)
      load(service.get("/zobjects/#{id}", zobject: zobject))
    end
    
    def create(zobject, attributes={})
      load(service.post("/zobjects", zobject: zobject, attributes: attributes))
    end
  end
end