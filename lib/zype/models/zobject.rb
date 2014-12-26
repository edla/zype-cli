module Zype
  class Zobject < Zype::Model

    def videos
      return [] if self.video_ids.empty?

      service.videos.all(id: self.video_ids)
    end

    def add_videos(zobject, video_ids)
      service.put("/zobjects/#{self['_id']}/add_videos", zobject_type: zobject, video_id: video_ids)
    end

    def remove_videos(zobject, video_ids)
      service.put("/zobjects/#{self['_id']}/remove_videos", zobject_type: zobject, video_id: video_ids)
    end

  end
end
