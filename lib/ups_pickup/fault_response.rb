module UpsPickup
  class FaultResponse < ErrorResponse
    attr_accessor :response
    def initialize(client,response)
      fault_client = client  
      fault_client.config.raise_errors = false
      @response = Savon::SOAP::Response.new(fault_client.config,response.http)
      
    end

  end
end