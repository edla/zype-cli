module Zype
  class DeviceCategories < Zype::Collection
    model DeviceCategory

    def all(device_category, params)
      load(service.get('/device_categories', params))
    end

    def find(device_category, id)
      load(service.get("/device_categories/#{id}"))
    end
  end
end
