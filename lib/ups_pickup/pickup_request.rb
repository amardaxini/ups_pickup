
module UpsPickup
  class PickupRequest 
    LIVE_URL = "https://onlinetools.ups.com/webservices/Pickup"
    TEST_URL= "https://wwwcie.ups.com/webservices/Pickup"
    include HTTParty
    base_uri LIVE_URL
    attr_accessor  :user_name,:password,:license,:options,:client,:client_response,:response,:error,:grand_total_of_all_charge
    def initialize(user_name, password, license, options={})
      @user_name,@password,@license,@options = user_name,password,license,options  
      @client=Savon.client(endpoint: wsdl_endpoint, wsdl: File.expand_path("../../schema/Pickup.wsdl", __FILE__))
      @request_body = {}
      set_soap_namespace
      if (options[:test] == true)
        self.class.base_uri TEST_URL
      elsif options[:url] && [LIVE_URL,TEST_URL].include?(options[:url])
        self.class.base_uri options[:url]
      end
    
      
    end

    
    # For Test environment set test url
    def wsdl_endpoint
      if @options[:test] == true
       TEST_URL
      else 
        LIVE_URL
      end   
    end
    # Set name space
    # ns2 for pickup 
    def set_soap_namespace
    
      # @client.wsdl.namespaces["xmlns:ns2"] = "http://www.ups.com/XMLSchema/XOLTWS/Pickup/v1.1"
      # @client.wsdl.namespaces["xmlns:ns3"] = "http://www.ups.com/XMLSchema/XOLTWS/UPSS/v1.0"
    end

    #Set security passed in client request block
    def access_request
     {   
      "ns3:UPSSecurity" => {
        "ns3:UsernameToken"=>{
          "ns3:Username"=>@user_name,
          "ns3:Password" => @password
        },
        "ns3:ServiceAccessToken"=>{
          "ns3:AccessLicenseNumber"=> @license
        }
        }
      } 
    end
    def soap_fault?
      @client_response.is_a?(Savon::SOAPFault)
    end

    def http_error?
      @client_response.is_a?(Savon::Error)
    end

    def success?
      @client_response.is_a?(Savon::Response)
    end
  end
end

# pickup = Ups::PickupRequest.new("contego.mtaylor","C0nt3g0!","6C82D38E41F9C600")