require 'ups_pickup/util'
module UpsPickup
  class PickupCreationSuccess
    include Util
    attr_accessor :prn,:rate_status,:success_code, :total, :grand_total_of_all_charge
    def initialize(response)
      response_hash = response.to_hash
      @prn = response_hash.deep_fetch(:prn)
      @rate_status = response_hash.deep_fetch(:rate_status)
      @success_code = response_hash.deep_fetch(:code)
      self.grand_total_of_all_charge = response_hash.deep_fetch(:grand_total_of_all_charge)
    end
  end
end
