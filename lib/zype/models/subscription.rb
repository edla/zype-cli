require 'pry'
module Zype
  class Subscription < Zype::Model
    def save
      binding.pry
      res = service.put("/subscriptions/#{self['_id']}", subscription: {
        # plan_id: title,
      })

      merge(res)
    end

    def destroy
      service.delete("/subscriptions/#{_id}")
      true
    end
  end
end
