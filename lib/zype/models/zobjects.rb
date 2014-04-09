module Zype
  class Zobjects < Zype::Collection
    model Zobject

    def all(zobject, filters={}, page=0, pagesize=10)
      load(service.get('/zobjects', zobject: zobject, filters: filters, page: page, pagesize: pagesize))
    end

    def find(zobject, id)
      load(service.get("/zobjects/#{id}", zobject: zobject))
    end

    def create(zobject, attributes={}, pictures={})
      load(service.post("/zobjects", zobject: zobject, attributes: attributes, pictures: pictures))
    end
  end
end