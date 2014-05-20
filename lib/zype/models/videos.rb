module Zype
  class Videos < Zype::Collection
    model Video

    def all(filters={}, page=0, per_page=10, sort=nil, order=nil)
      load(service.get('/videos', filters: filters, page: page, per_page: per_page, sort: sort, order: order))
    end

    def find(id)
      load(service.get("/videos/#{id}"))
    end

    def create(attributes={})
      load(service.post("/videos", video: attributes))
    end

    def embed(id, options = {})
      load(service.get("/videos/#{id}/player", options: options))
    end

    def search(search_terms, page=0, per_page=10, sort=nil, order=nil)
      load(service.get('/videos/search', search_terms: search_terms, page: page, per_page: per_page, sort: sort, order: order))
    end
  end
end
