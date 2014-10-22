require 'pry'
module Zype
  class Customer < Zype::Model

    def video_favorites(options = {})
      service.get("/customers/#{self['_id']}/video_favorites", options)["response"]
    end

    def favorite_video(video_id=nil)
      binding.pry
      service.post("/customers/#{self['_id']}/video_favorites", video_id: video_id)
    end

    def unfavorite_video(video_id=nil)
      binding.pry
      # Use the video_id and customer_id to get the video_favorite_id
      service.delete("/customers/#{self['id']}/video_favorites/#{video_favorite_id}")
    end
  end
end
