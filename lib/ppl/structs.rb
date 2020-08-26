module Ppl
  Address = Struct.new(
    :city,
    :contact,
    :country,
    :email,
    :name,
    :name2,
    :phone,
    :street,
    :zip_code,
    keyword_init: true
  ) do
    def to_xml
      to_h.deep_transform_keys! { |key| key.to_s.camelcase }
    end
  end

  Order = Struct.new(
    :packages_count,
    :customer_reference,
    :email,
    :note,
    :order_reference_id,
    :package_product_type,
    :send_date,
    :send_time_from,
    :send_time_to,
    :sender,
    :recipient,
    keyword_init: true
  ) do
    def initialize(*args)
      super(*args)

      %i(send_date send_time_from send_time_to).each do |attribute|
        if self[attribute].present? && !self[attribute].is_a?(DateTime)
          self[attribute] = DateTime.parse(self[attribute])
        end
      end

      %i(
        order_reference_id package_product_type packages_count send_date sender
        recipient
      ).each do |attribute|
        unless self[attribute].present?
          raise Ppl::Errors::AttributeRequired, "#{attribute} is required."
        end
      end

      unless sender.is_a?(Ppl::Address)
        raise Ppl::Errors::Type, "Sender has to be an Address."
      end

      unless recipient.is_a?(Ppl::Address)
        raise Ppl::Errors::Type, "Recipient has to be an Address."
      end
    end

    def to_xml
      {
        "MyApiOrderIn" => {
          "OrdRefId" => order_reference_id,
          "PackProductType" => package_product_type,
          "CountPack" => packages_count,
          "CustRef" => customer_reference,
          "Email" => email,
          "Note" => note,
          "SendDate" => send_date.to_s,
          "SendTimeFrom" => send_time_from.to_s,
          "SendTimeTo" => send_time_to.to_s,
          "Sender" => sender.to_xml,
          "Recipient" => recipient.to_xml
        }
      }
    end
  end
end
