module Zype
  class DataSources < Zype::Collection
    model DataSource

    def all(filters={}, page=0, pagesize=10)
      load(service.get('/data_sources', filters: filters, page: page, pagesize: pagesize))
    end

    def find(id)
      load(service.get("/data_sources/#{id}"))
    end
    
    def create(attributes={})
      load(service.post("/data_sources", attributes: attributes))
    end
  end
end