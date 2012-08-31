
module UpsPickup
  class PickupCancel < PickupRequest
    def initialize(user_name, password, license, options={})
      super(user_name, password, license, options)  
      @cancel_by = options[:cancel_by] || "02"
      @prn = options[:prn]
    end

    def to_ups_hash
      {
        "ns2:CancelBy"=>@cancel_by,
        "ns2:PRN"=>@prn
      }
    end
    
    def build_request
      self.to_ups_hash
    end

    def commit
      begin
        @client_response = @client.request  :ns2,"PickupCancelRequest" do
          #soap.namespaces["xmlns:S"] = "http://schemas.xmlsoap.org/soap/envelope/"
          #soap.namespaces["xmlns:upss"] = "http://www.ups.com/XMLschema/XOLTWS/UPSS/v1.0"
          #soap.namespaces["xmlns:ns1"] = "http://www.ups.com/XMLSchema/XOLTWS/Common/v1.0"
          soap.namespaces["xmlns:ns3"] = "http://www.ups.com/XMLSchema/XOLTWS/UPSS/v1.0"
          soap.namespaces["xmlns:ns2"] = "http://www.ups.com/XMLSchema/XOLTWS/Pickup/v1.1"
        #  soap.header = SOAP_HEADER1
          soap.header = access_request
          soap.body = build_request
        end
      rescue Savon::SOAP::Fault => fault
        @client_response = fault
      rescue Savon::Error => error
        @client_response = error   
      end  
      build_response
    end

    def build_response
      if success?
        @response = UpsPickup::PickupCancelSuccess.new(@client_response) 
      elsif soap_fault?
        fault_response = UpsPickup::FaultResponse.new(@client,@client_response)
        @error = UpsPickup::ErrorResponse.new(fault_response.response)
      end  
    end
  end
end

