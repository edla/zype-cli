module Zype
  class Videos < Zype::Collection
    model Video

    def all(filters={}, page=0, pagesize=10)
      load(service.get('/videos', filters: filters, page: page, pagesize: pagesize))
    end

    def find(id)
      load(service.get("/videos/#{id}"))
    end

    def create(attributes={})
      load(service.post("/videos", video: attributes))
    end

    def play(id, container, options = {})
      load(service.get("/videos/#{id}/play", container: container, options: options))
    end
  end
end