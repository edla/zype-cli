module Zype
  class Playlist < Zype::Model
    def destroy
      service.delete("/playlists/#{_id}")
      true
    end

    def videos(params={})
      Zype::Videos.new.load(service.get("/playlists/#{_id}/videos", params))
    end
  end
end
