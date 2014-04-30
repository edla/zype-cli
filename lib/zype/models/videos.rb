module Zype
  class Videos < Zype::Collection
    model Video

    def all(filters={}, page=0, per_page=10)
      load(service.get('/videos', filters: filters, page: page, per_page: per_page))
    end

    def find(id)
      load(service.get("/videos/#{id}"))
    end
    
    def create(attributes={})
      load(service.post("/videos", video: attributes))
    end
  end
end