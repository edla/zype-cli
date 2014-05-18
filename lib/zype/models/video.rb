module Zype
  class Video < Zype::Model
    def save
      res = service.put("/videos/#{self['_id']}", video: {
        title: title,
        keywords: keywords
      })

      merge(res)
    end

    def player(options = {})
      load(service.get("/videos/#{self['_id']}/player", options: options))
    end
  end
end
