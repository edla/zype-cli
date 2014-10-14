module Zype
  class Customers < Zype::Collection
    model Customer

    def all(params={})
      load(service.get('/customers', params))
    end

    def find(id)
      load(service.get("/customers/#{id}"))
    end

  end
end
