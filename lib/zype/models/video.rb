module Zype
  class Video < Zype::Model
    def save
      res = service.put("/videos/#{self['_id']}", video: {
        title: title,
        keywords: keywords,
        active: active,
        featured: featured,
        description: description
      })

      merge(res)
    end

    def player(options = {})
      service.get("/videos/#{self['_id']}/player", options)["response"]
    end

    def add_zobjects(zobject_ids)
      service.put("/videos/#{self['_id']}/add_zobjects", zobject_id: zobject_ids)
    end

    def remove_zobjects(zobject_ids)
      service.put("/videos/#{self['_id']}/remove_zobjects", zobject_id: zobject_ids)
    end
  end
end
