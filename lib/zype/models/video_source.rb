module Zype
  class VideoSource < Zype::Model
    def destroy
      service.delete("/video_sources/#{_id}")
      true
    end
  end
end
