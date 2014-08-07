module Zype
  class Zobjects < Zype::Collection
    model Zobject

    def all(zobject, params)
      load(service.get('/zobjects', params.merge(zobject: zobject)))
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
  end
end
