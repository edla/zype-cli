module Zype
  class Subscription < Zype::Model
    def destroy
      service.delete("/subscriptions/#{_id}")
      true
    end
  end
end
