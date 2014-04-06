module Zype
  class VideoSources < Zype::Collection
    model VideoSource

    def all(filters={}, page=0, pagesize=10)
      load(service.get('/video_sources', filters: filters, page: page, pagesize: pagesize))
    end

    def find(id)
      load(service.get("/video_sources/#{id}"))
    end
    
    def create(attributes={})
      load(service.post("/video_sources", attributes: attributes))
    end
  end
end