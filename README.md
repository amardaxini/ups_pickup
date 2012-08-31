# UpsPickup

UPS Pickup Request API

## Installation

Add this line to your application's Gemfile:

    gem 'ups_pickup'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ups_pickup

## Usage

    username = ""
    password = ""
    license = ""

    # Ups Pickup creation
    options= {:url=>("https://onlinetools.ups.com/webservices/Pickup" or "https://wwwcie.ups.com/webservices/Pickup"),
        :address_line=>"New york",:city=>"New york",
        :company_name=>"Broadway Avenue",:contact_name=>"Amar",:state=>"NY",:country_code=>"US",
        :phone_number=>"212-632-3975",:pickup_date=>"20120830",
        :close_time =>"1630",:ready_time=> "0800",:service_code=>"001",
        :weight=>"42.0",:postal_code=>"10020",:account_number=>"243AV3",:payment_method=>"01" 
    }


    u = UpsPickup::PickupCreation.new(username,password,license,options)
    u.commit
    u.response #return object which has prn,and rate_status,success_code if it's success
    u.error    # if any error return object which has severity,and error_code,description if it's fail

    #Ups Pickup Cancel
    options= {:url=>("https://onlinetools.ups.com/webservices/Pickup" or "https://wwwcie.ups.com/webservices/Pickup"),
               :prn=>"PRN NO",:cancel_by=>"02"}     
    u.response 
    u.error    

    # Find out success or fault
    u.success?
    u.soap_fault?
    u.http_error?


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
