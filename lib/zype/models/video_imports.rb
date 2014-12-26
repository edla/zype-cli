module Zype
  class VideoImports < Zype::Collection
    model VideoImport

    def all(params={})
      load(service.get('/video_imports', params))
    end

    def find(id)
      load(service.get("/video_imports/#{id}"))
    end
  end
end
