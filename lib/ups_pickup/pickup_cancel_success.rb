module UpsPickup
  class PickupCancelSuccess
    include Util
    attr_accessor :response_status,:code,:description,:pickup_type
    def initialize(response)
      response_hash = response.to_hash
      @response_status = response_hash.deep_fetch(:response_status)
      @code = response_hash.deep_fetch(:code)
      @description = response_hash.deep_fetch(:description)
      @pickup_type = response_hash.deep_fetch(:pickup_type)
    end
  end
end