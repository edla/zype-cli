module Zype
  class DataSource < Zype::Model
    def destroy
      service.delete("/data_sources/#{id}")
      true
    end
  end
end