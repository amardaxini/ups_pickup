require 'ups_pickup/util'
module UpsPickup
  class PickupCreation < PickupRequest
    include Util
    attr_accessor  :response,:error
    def initialize(user_name, password, license, options={})
      super(user_name, password, license, options)
      @rate_pickup_indicator = set_yes_or_no_option(@options[:rate_pickup_indicator])
      # iF any one packge is above 70lbs or 32 kg then its true
      @over_weight_indicator = set_yes_or_no_option(@options[:rate_pickup_indicator])
      @reference_number = @options[:reference_number]
      @special_instruction = @options[:special_instruction]
      @pickup_address = UpsPickup::PickupAddress.new(options)
      @shipper = UpsPickup::Shipper.new(options)
      @alternate_address_indicator = @options[:alternate_address_indicator].nil? ? "N" : @options[:alternate_address_indicator]
      @tracking_data = []
      @pickup_pieces = set_pickup_piece
      set_tracking_data
      set_weight
      set_pickup_date_info
      set_payment_method
      set_notification
      set_undelivered_email
    end
    #options=>{:pickup_piece=>{:service_code=>,:qty}}
    # or options=>{:pickup_piece=>[{:service_code=>,:qty},{:service_code=>,:qty}]}

    #TODO need to check wether savon is iterating array or not
    def set_pickup_piece
      if @options[:pickup_piece]
        if @options[:pickup_piece].is_a?(Array)
          @options[:pickup_piece].each do |pp|
            @pickup_pieces << Ups::PickupPiece.new(pp)
          end
        elsif @options[:pickup_piece].is_a?(Hash)
          @pickup_pieces =[UpsPickup::PickupPiece.new(@options[:pickup_piece])]
        end
      else
        @pickup_pieces =[UpsPickup::PickupPiece.new(@options)]
      end
    end

    def pickup_piece_ups_hash
      pickup_hashes = []
      if @pickup_pieces
        @pickup_pieces.flatten.each do |pp|

          pickup_hashes<< [pp.to_ups_hash]
        end
      end
      pickup_hashes.flatten
    end

    def set_tracking_data
      if @options[:tracking_data].is_a?(Array)
        @options[:tracking_data].each do |tracking_number|
          @tracking_data << UpsPickup::TrackingData.new(tracking_number)
        end
      else
        @tracking_data = []
      end
    end

    def tracking_data_ups_hash
      tracking_hashes = []
      if @tracking_data
        @tracking_data.flatten.each do |tracking_number|

          tracking_hashes << [tracking_number.to_ups_hash]
        end
      end
      tracking_hashes.flatten
    end

    def set_weight
      @weight = @options[:weight]
      #LBS or KGS
      @unit_of_weight = @options[:unit_of_weight] || "LBS"
    end

    def set_pickup_date_info
      @close_time = @options[:close_time]
      @ready_time = @options[:ready_time]
      @pickup_date = Date.parse(@options[:pickup_date]).strftime("%Y%m%d")
    end
    # The payment method to pay for this on call pickup.
    #  00 = No payment needed
    #  01 = Pay by shipper account
    #  03 = Pay by charge card
    #  04 = Pay by tracking number
    #  05 = Pay by check or money order
    def set_payment_method
      @payment_method = options[:payment_method] if !options[:payment_method].nil? && [0,1,2,3,4,5].include?(options[:payment_method].to_i)
      @payment_method ||="00"
    end

    # it might be an array of email address or single email address
    # max allowed limit is 5
    def set_notification
      @confirmation_email_address = [@options[:confirmation_email_address]][0...5].flatten.uniq.compact
    end

    def set_undelivered_email
      @undelivered_email
    end

    def build_request
      {
        "ns2:Request"=>{
        "ns2:RequestOption"=>"1"
        },
        "ns2:RatePickupIndicator"=>@rate_pickup_indicator,

        "ns2:Shipper"=>@shipper.to_ups_hash,
        "ns2:PickupDateInfo"=>{
          "ns2:CloseTime"=>@close_time,
          "ns2:ReadyTime" => @ready_time,
          "ns2:PickupDate" =>@pickup_date
        },
        "ns2:PickupPiece"=>pickup_piece_ups_hash,
        "ns2:PickupAddress"=>@pickup_address.to_ups_hash,
        "ns2:AlternateAddressIndicator"=>@alternate_address_indicator,
        "ns2:PaymentMethod"=>@payment_method,
        "ns2:OverweightIndicator"=>@over_weight_indicator,
        "ns2:SpecialInstruction"=>@special_instruction,
        "ns2:ReferenceNumber"=>@reference_number,
        "ns2:Notfication"=>{
          "ns2:ConfirmationEmailAddress"=>@confirmation_email_address
        },
        "ns2:TrackingData"=>tracking_data_ups_hash
      }
    end

    def commit
      begin
        @client_response = @client.request  :ns2,"PickupCreationRequest" do
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

    def build_response
      if success?
        @response = UpsPickup::PickupCreationSuccess.new(@client_response)
        self.grand_total_of_all_charge = @response.grand_total_of_all_charge
      elsif soap_fault?
        fault_response = UpsPickup::FaultResponse.new(@client,@client_response)
        @error = UpsPickup::ErrorResponse.new(fault_response.response)
      end
    end



  end
end
