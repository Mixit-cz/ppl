module Ppl
  class Package
    attr_accessor :package_number,
    :cash_on_delivery_price,
    :cash_on_delivery_currency,
    :recipient_name,
    :recipient_street,
    :recipient_city,
    :recipient_country,
    :recipient_zip_code,
    :recipient_phone,
    :sender_name,
    :sender_street,
    :sender_city,
    :sender_country,
    :sender_zip_code,
    :package_position,
    :package_count,
    :package_number_checksum

    def initialize(params)
      params.each do |k, v|
        send("#{k}=", v)
      end
    end

    def cash_on_delivery?
      true
    end

    def evening_delivery?
      true
    end
  end
end
