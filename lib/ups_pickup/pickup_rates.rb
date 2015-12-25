require 'ups_pickup/util'
module UpsPickup
  class PickupRates < PickupCreation

    def build_request
      {
        "ns2:Request"=>{},
        "ns2:PickupAddress"=>@pickup_address.to_ups_hash,
        "ns2:AlternateAddressIndicator"=>'Y',
        "ns2:ServiceDateOption"=>'01',
        "ns2:PickupDateInfo"=>{
          "ns2:CloseTime"=>@close_time,
          "ns2:ReadyTime" => @ready_time,
          "ns2:PickupDate" =>@pickup_date
        }
      }
    end

    def commit
      begin
        @client_response = @client.request  :ns2,"PickupRateRequest" do
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
        @clien_response = error   
      end  
      build_response
    end
  end
end
