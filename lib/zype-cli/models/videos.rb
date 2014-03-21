module ZypeCli
  class Videos < ZypeCli::Collection
    model Video

    def all(filters={}, page=0, pagesize=10)
      load(service.get('/videos', filters: filters, page: page, pagesize: pagesize))
    end

    def find(id)
      load(service.get("/videos/#{id}"))
    end
  end
end