require 'ups_pickup/util'
module UpsPickup
  class ErrorResponse
    include Util
    attr_accessor :error_code,:severity,:description
    # currently building for error 
    def initialize(response)
      response_hash = response.to_hash

      @severity = response_hash.deep_fetch(:severity)
      @error_code = response_hash.deep_fetch(:code)
      @description =response_hash.deep_fetch(:description)
    end

    

  end
end