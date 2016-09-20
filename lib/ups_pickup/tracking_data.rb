module UpsPickup
  class TrackingData
    attr_reader :tracking_number

    def initialize(tracking_number)
      raise StandardError.new("Missing Tracking Number") unless tracking_number
      @tracking_number = tracking_number
    end

    def to_ups_hash
      {
        "ns2:TrackingNumber" => @tracking_number
      }
    end
  end
end
