module Zype
  class Playlists < Zype::Collection
    model Playlist

    def all(filters={}, page=0, per_page=10)
      load(service.get('/playlists', filters: filters, page: page, per_page: per_page))
    end

    def find(id)
      load(service.get("/playlists/#{id}"))
    end

    def create(attributes={})
      load(service.post("/playlists", playlist: attributes))
    end

    def update(id, attributes={}, video_id=nil, position=nil)
      load(service.put("/playlists/#{id}", playlist: attributes, video_id: video_id, position: position))
    end
  end
end