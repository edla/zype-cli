module ZypeCli
  class Zobjects < ZypeCli::Collection
    model Zobject
    
    def all(zobject, filters={})
      load(service.get('/zobjects', zobject: zobject, filters: filters))
    end
    
    def find(zobject, id)
      load(service.get("/zobjects/#{id}", zobject: zobject))
    end
  end
end