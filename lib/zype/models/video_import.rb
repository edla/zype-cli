module Zype
  class VideoImport < Zype::Model
    def add_video(video_id=nil)
      if video_id
        service.put("/video_imports/#{self['_id']}/add_video", video_id: video_id)
      else
        service.put("/video_imports/#{self['_id']}/add_video")
      end
    end
  end
end
