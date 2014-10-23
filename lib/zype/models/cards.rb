module Zype
  class Cards < Zype::Collection
    model Card

    def all(consumer_id,params={})
      load(service.get("/consumers/#{consumer_id}/cards", params))
    end

    def find(consumer_id,id)
      load(service.get("/consumers/#{consumer_id}/cards/#{id}"))
    end

    def create(consumer_id,attributes={})
      load(service.post("/consumers/#{consumer_id}/cards", card: attributes))
    end
  end
end
