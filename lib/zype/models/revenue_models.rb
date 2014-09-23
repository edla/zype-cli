module Zype
  class RevenueModels < Zype::Collection
    model RevenueModel

    def all(params={})
      load(service.get('/revenue_models', params))
    end

    def find(id)
      load(service.get("/revenue_models/#{id}"))
    end

  end
end
