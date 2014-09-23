module Zype
  class DeviceCategories < Zype::Collection
    model DeviceCategory

    def all(params={})
      load(service.get('/device_categories', params))
    end

    def find(id)
      load(service.get("/device_categories/#{id}"))
    end
  end
end
