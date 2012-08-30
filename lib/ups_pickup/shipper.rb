module Ups
  class Shipper
    attr_accessor :account_number,:account_country_code,:card_hoder_name,:card_type,:card_number
    attr_accessor :expiration_date,:security_code,:card_address,:payment_method
    # options=>{:card_address=>{:state=>,:city=>,...}}
    # Valid Card Type values are :
    # 01 = American Express
    # 03 = Discover
    # 04 = Mastercard
    # 06 = VISA
    def initialize(options={})
      @account_number = options[:account_number]
      @account_country_code = options[:account_country_code] || "US"
      @card_hoder_name = options[:card_hoder_name]
      # TODO Validate card type  01 = American Express 03 = Discover 04 = Mastercard  06 = VISA
      # if country code is US and payment method is 3
      @card_type = options[:card_type]
      @card_number = options[:card_number]
      @expiration_date = options[:expiration_date]
      @security_code = options[:security_code]
      @card_address = Ups::Address.new(options[:card_address])
      #TODO raise an exception for payment method
      @payment_method = options[:payment_method] if !options[:payment_method].nil? && [0,1,2,3,4,5].include?(options[:payment_method].to_i)
      @payment_method ||="00"
    end

    def to_ups_hash
      
      if @payment_method.to_i == 3
        {
         "ns2:Account"=>{
          "AccountNumber"=>@account_number,
          "AccountCountryCode"=>@account_country_code
          },
        "ns2:ChargeCard"=>{
          "ns2:CardType"=>@card_type,
          "ns2:CardNumber"=>@card_number,
          "ns2:ExpirationDate"=>@expiration_date,
          "ns2:SecurityCode"=>@security_code,
          "ns2:CardAddress"=>{
            "ns2:AddressLine"=>@card_address.to_ups_hash
            } 
          }
        }
      else
        {
         "ns2:Account"=>{
          "ns2:AccountNumber"=>@account_number,
          "ns2:AccountCountryCode"=>@account_country_code
          }
        }  
      end  

    end

  end
end