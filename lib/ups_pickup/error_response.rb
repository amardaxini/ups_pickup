module UpsPickup
  class ErrorResponse
    include UpsPickup::Util
    attr_accessor :error_code,:severity,:description
    # currently building for error 
    def initialize(response)
      response_hash = response.to_hash

      @severity = deep_find(response_hash,:severity)
      @error_code = deep_find(response_hash,:code)
      @description =deep_find(response_hash,:description)
    end

    

  end
end