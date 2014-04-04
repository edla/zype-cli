module Zype
  class Upload < Zype::Model
    def save
      res = service.put("/uploads/#{self['_id']}", upload: {
        progress: progress,
        status: status
      })
      
      merge(res)
    end
  end
end