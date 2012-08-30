require 'ups_pickup/util'
module UpsPickup
  class PickupCreationSuccess
    include Util
    attr_accessor :prn,:rate_status,:success_code
    def initialize(response)
      response_hash = response.to_hash
      @prn = deep_find(response_hash,:prn)
      @rate_status = deep_find(response_hash,:rate_status)
      @success_code = deep_find(response_hash,:code)
    end
  end
end
