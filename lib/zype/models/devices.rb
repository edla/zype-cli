module Zype
  class Devices < Zype::Collection
    model Device

    def all(device, params)
      load(service.get('/devices', params))
    end

    def find(device, id)
      load(service.get("/devices/#{id}"))
    end
  end
end
