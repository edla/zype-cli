module Zype
  class Devices < Zype::Collection
    model Devices

    def all(params={})
      load(service.get('/devices', params))
    end

    def find(id)
      load(service.get("/devices/#{id}"))
    end

  end
end
