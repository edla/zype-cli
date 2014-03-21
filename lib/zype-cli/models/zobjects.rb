module ZypeCli
  class Zobjects < ZypeCli::Collection
    model Zobject

    def all(zobject, filters={}, page=0, pagesize=10)
      load(service.get('/zobjects', zobject: zobject, filters: filters, page: page, pagesize: pagesize))
    end

    def find(zobject, id)
      load(service.get("/zobjects/#{id}", zobject: zobject))
    end
  end
end