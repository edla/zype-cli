module Zype
  class Zobjects < Zype::Collection
    model Zobject

    def all(zobject, params)
      load(service.get('/zobjects', params.merge(zobject_type: zobject)))
    end

    def find(zobject, id)
      load(service.get("/zobjects/#{id}", zobject_type: zobject))
    end

    def import(zobject, filename)
      load(service.post("/zobjects/import", zobject_type: zobject, filename: filename))
    end

    def create(zobject, attributes={})
      load(service.post("/zobjects", zobject_type: zobject, zobject: attributes))
    end
  end
end
