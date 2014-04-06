module Zype
  class Video < Zype::Model
    def save
      res = service.put("/videos/#{self['_id']}", video: {
        title: title,
        keywords: keywords
      })
      
      merge(res)
    end
  end
end