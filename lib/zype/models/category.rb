module Zype
  class Category < Zype::Model
    def save
      res = service.put("/categories/#{self['_id']}", category: {
        title: title,
        values: self[:values]
      })

      merge(res)
    end

    def destroy
      service.delete("/categories/#{_id}")
      true
    end

  end
end
