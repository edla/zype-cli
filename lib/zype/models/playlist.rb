module Zype
  class Playlist < Zype::Model
    def destroy
      service.delete("/playlists/#{_id}")
      true
    end

    def videos(params={})
      Zype::Videos.new.load(service.get("/playlists/#{_id}/videos", params))
    end

    def add_videos(video_ids)
      service.put("/playlists/#{self['_id']}/add_videos", video_id: video_ids)
    end

    def remove_videos(video_ids)
      service.put("/playlists/#{self['_id']}/remove_videos", video_id: video_ids)
    end
  end
end
