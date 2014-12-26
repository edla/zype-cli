module Zype
  class VideoSource < Zype::Model
    def save
      res = service.put("/video_sources/#{self['_id']}", video_source: {
        name: name,
        guid: guid
      })

      merge(res)
    end

    def destroy
      service.delete("/video_sources/#{_id}")
      true
    end
  end
end
