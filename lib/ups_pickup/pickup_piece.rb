module UpsPickup
  class PickupPiece
    #attr_accessor :service_code
    def initialize(options={})
      @service_code = options[:service_code] || "001"
      @quantity =options[:quantity] || "1"
      @destination_country_code = options[:destination_country_code] || "US"
      @container_code = options[:container_code] || "01"
    end

    def to_ups_hash
      {
        "ns2:ServiceCode"=>@service_code,
        "ns2:Quantity" =>@quantity,
        "ns2:DestinationCountryCode"=>@destination_country_code,
        "ns2:ContainerCode"=>@container_code
      }  
    end
  end
end