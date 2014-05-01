module Zype
  class Zobject < Zype::Model

    def videos
      array = self.video_ids
      videos = []
      unless array.empty?
        id_string = array.join(',')
        videos.push(service.videos.find(id_string)).flatten
      end
    end

  end
end