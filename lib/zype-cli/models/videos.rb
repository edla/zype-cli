module ZypeCli
  class Videos < ZypeCli::Collection
    model Video
    
    def all(filters={})
      load(service.get('/videos', filters: filters))
    end
    
    def find(id)
      load(service.get("/videos/#{id}"))
    end
  end
end