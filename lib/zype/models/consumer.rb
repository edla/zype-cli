module Zype
  class Consumer < Zype::Model

    def video_favorites(options = {})
      service.get("/consumers/#{self['_id']}/video_favorites", options)["response"]
    end

    def favorite_video(video_id=nil)
      service.post("/consumers/#{self['_id']}/video_favorites", video_id: video_id)
    end

    def unfavorite_video(video_id=nil)
      video_favorite = video_favorites.find(video_id: video_id).first

      service.delete("/consumers/#{self['_id']}/video_favorites/#{video_favorite['_id']}")
    end
  end
end
