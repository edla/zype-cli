module Zype
  class Zobject < Zype::Model

    def videos
      array = self.video_ids
      videos = []
      unless array.empty?
        id_string = array.join(',')
        videos += service.videos.find(id_string)
      end
      videos.flatten
    end

  end
end