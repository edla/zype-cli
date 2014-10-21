module Zype
  class Subscriptions < Zype::Collection
    model Subscription

    def all(params={})
      load(service.get('/subscriptions', params))
    end

    def find(id)
      load(service.get("/subscriptions/#{id}"))
    end

    def create(attributes={})
      load(service.post("/subscriptions", subscription: attributes))
    end
  end
end
