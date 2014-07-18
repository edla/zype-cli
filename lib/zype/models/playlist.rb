module Zype
  class Playlist < Zype::Model
    def destroy
      service.delete("/playlists/#{_id}")
      true
    end

    def videos
      Zype::Videos.new.load(service.get("/playlists/#{_id}/videos"))
    end
  end
end
