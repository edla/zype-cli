module Zype
  class Plans < Zype::Collection
    model Plan

    def all(params={})
      load(service.get('/plans', params))
    end

    def find(id)
      load(service.get("/plans/#{id}"))
    end

  end
end
