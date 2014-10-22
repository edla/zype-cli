module Zype
  class Cards < Zype::Collection
    model Card

    def all(customer_id,params={})
      load(service.get("/customers/#{customer_id}/cards", params))
    end

    def find(customer_id,id)
      load(service.get("/customers/#{customer_id}/cards#{id}"))
    end

    def create(customer_id,attributes={})
      load(service.post("/customers/#{customer_id}/cards", card: attributes))
    end
  end
end
