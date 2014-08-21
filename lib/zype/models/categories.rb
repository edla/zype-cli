module Zype
  class Categories < Zype::Collection
    model Category

    def all(params={})
      load(service.get('/categories', params))
    end

    def find(id)
      load(service.get("/categories/#{id}"))
    end

    def create(attributes={})
      load(service.post("/categories", category: attributes))
    end

    def update(id, attributes={}, video_id=nil, position=nil)
      load(service.put("/categories/#{id}", category: attributes, video_id: video_id, position: position))
    end
  end
end
