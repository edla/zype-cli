module Zype
  class Videos < Zype::Collection
    model Video

    def all(params={})
      load(service.get('/videos', params))
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
  end
end
