module Zype
  class Upload < Zype::Model
    def save
      res = service.put("/uploads/#{self['_id']}", upload: {
        progress: progress,
        status: status,
        message: message
      })
      
      merge(res)
    end
  end
end