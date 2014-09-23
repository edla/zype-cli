module Zype
  class Devices < Zype::Collection
    model Device

    def all(params={})
      load(service.get('/devices', params))
    end

    def find(id)
      load(service.get("/devices/#{id}"))
    end

  end
end
