module Zype
  class ZobjectType < Zype::Model
    def save
      res = service.put("/zobject_types/#{self['_id']}", zobject_type: {
        title: title,
        description: description,
        videos_enabled: videos_enabled
      })

      merge(res)
    end
  end
end