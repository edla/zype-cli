module Zype
  class Subscription < Zype::Model
    def save
      res = service.put("/subscriptions/#{self['_id']}", subscription: {
        plan_id: plan_id
      })

      merge(res)
    end

    def destroy
      service.delete("/subscriptions/#{_id}")
      true
    end
  end
end
