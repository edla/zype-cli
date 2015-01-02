module Zype
  class VideoSources < Zype::Collection
    model VideoSource

    def all(filters={}, page=0, per_page=10)
      load(service.get('/video_sources', filters: filters, page: page, per_page: per_page))
    end

    def find(id)
      load(service.get("/video_sources/#{id}"))
    end

    def create(source, attributes={})
      load(service.post("/video_sources", source: source, video_source: attributes))
    end
  end
end
