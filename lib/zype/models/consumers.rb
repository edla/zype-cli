module Zype
  class Consumers < Zype::Collection
    model Consumer

    def all(params={})
      load(service.get('/consumers', params))
    end

    def find(id)
      load(service.get("/consumers/#{id}"))
    end

    def create(attributes={})
      load(service.post("/consumers", consumer: attributes))
    end
  end
end
