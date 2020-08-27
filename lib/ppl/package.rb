module Ppl
  Package = Struct.new(
    :package_number,
    :cash_on_delivery_price,
    :cash_on_delivery_currency,
    :sender,
    :recipient,
    :package_position,
    :package_count,
    :package_number_checksum,
    :package_product_type,
    keyword_init: true
  ) do
    def initialize(*args)
      super(*args)

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

      if special_delivery.present? && !special_delivery.is_a?(Ppl::SpecialDelivery)
        raise Ppl::Errors::Type, "Special delivery has to be a SpecialDelivery."
      end

      if payment_info.present? && !payment_info.is_a?(Ppl::PaymentInfo)
        raise Ppl::Errors::Type, "Payment info has to be a PaymentInfo."
      end
    end

    def package_services
      Array(self[:package_services]).map do |service|
        {
          "SvcCode" => service
        }
      end
    end

    def to_xml
      {
        "MyApiPackageIn" => {
          "PackNumber" => package_number,
          "PackProductType" => package_product_type,
          "Weight" => weight,
          "Note" => note,
          "DepoCode" => depo_code,
          "Sender" => sender.to_xml,
          "Recipient" => recipient.to_xml,
          "SpecDelivery" => special_delivery&.to_xml,
          "PaymentInfo" => payment_info&.to_xml,
          "PackageExtNums" => {
            "MyApiPackageExtNum" => package_external_numbers&.map(&:to_xml)
          },
          "PackageServices" => {
            "MyApiPackageInServices" => package_services
          },
          "Flags" => {
            "MyApiFlag" => flags&.map(&:to_xml)
          },
          "PalletInfo" => pallet_info&.to_xml,
          "WeightedPackageInfoIn" => weighted_package_info&.to_xml
        }
      }
    end
  end
end
