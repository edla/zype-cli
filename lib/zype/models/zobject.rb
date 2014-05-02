module Zype
  class Zobject < Zype::Model

    def videos
      return [] if self.video_ids.empty?
      
      service.videos.all(id: self.video_ids)
    end

  end
end