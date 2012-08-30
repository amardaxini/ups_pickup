module UpsPickup
  
  class Address
   
    attr_accessor :address_line,:city, :state, :country,:postal_code,:country_code
    def initialize(options={})
      options ||={}
      @address_line = options[:address_line]
      @city = options[:city]
      @state = options[:state]
      @postal_code = options[:postal_code]
      #@country = options[:country_code]
      @country_code = options[:country_code] || "US"
    end

    def to_ups_hash
      {
      "ns2:AddressLine"=>@address_line,
      "ns2:City"=>@city,
      "ns2:StateProvince"=>@state,
      "ns2:PostalCode"=>@postal_code,
      "ns2:CountryCode"=>@country_code
      }
    end
  end 

  class PickupAddress < Address
    ADDRESS_TYPES = {:residential=>"Y",:commercial=>"N"} 
    attr_accessor :company_name,:contact_name,:room,:floor , :residential_indicator,:pickup_point,:phone_number,:extension
    def initialize(options={})
      super(options)
      @company_name =options[:company_name]
      @contact_name = options[:contact_name]
      @room = options[:room]
      @floor = options[:floor]
      @residential_indicator = options[:residential_indicator] || "N" #ADDRESS_TYPES[options[:type]]
      @pickup_point = options[:pickup_point]
      @phone_number = options[:phone_number]
      @extension = options[:extension]

    end
    def to_ups_hash
      {
        "ns2:CompanyName"=>@company_name,
        "ns2:ContactName"=>@contact_name, 
        "ns2:AddressLine"=>@address_line,
        "ns2:Floor"=>@floor,
        "ns2:Room"=>@room,
        "ns2:City"=>@city,
        "ns2:StateProvince"=>@state,
        "ns2:PostalCode"=>@postal_code,
        "ns2:CountryCode"=>@country_code,
        "ns2:ResidentialIndicator"=>@residential_indicator,
        "ns2:PickupPoint"=>@pickup_point,
        "ns2:Phone"=>{
          "ns2:Number"=>@phone_number,
          "ns2:Extension"=>@extension
        }

      }
    end
  end
end  