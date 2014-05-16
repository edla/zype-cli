module Zype
  class Searches < Zype::Collection
    model Search

    def all(search_terms, page=0, per_page=10, sort= "title", order="asc")
      load(service.get('/search', search_terms: search_terms, page: page, per_page: per_page, sort: sort, order: order))
    end

  end
end
