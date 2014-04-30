module Zype
  class Uploads < Zype::Collection
    model Upload

    def all(filters={}, page=0, per_page=10)
      load(service.get('/uploads', filters: filters, page: page, per_page: per_page))
    end

    def find(id)
      load(service.get("/uploads/#{id}"))
    end
    
    def create(attributes={})
      load(service.post("/uploads", upload: attributes))
    end
  end
end