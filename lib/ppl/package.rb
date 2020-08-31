module Ppl
  Package = Struct.new(
    :package_number,
    :sender,
    :recipient,
    :package_position,
    :package_count,
    :package_product_type,
    :depo_code,
    :special_delivery,
    :payment_info,
    :pallet_info,
    :external_numbers,
    :weighted_package_info,
    :package_services,
    :flags,
    :weight,
    :note,
    keyword_init: true
  ) do
    def initialize(*args)
      super(*args)

      %i(
        package_number package_product_type package_count recipient
      ).each do |attribute|
        unless self[attribute].present?
          raise Ppl::Errors::AttributeRequired, "#{attribute} is required."
        end
      end

      if sender.present? && !sender.is_a?(Ppl::Address)
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

    def cod?
      Product::CASH_ON_DELIVERY.include?(package_product_type)
    end

    def evening_delivery?
      self[:package_services] && self[:package_services].include?("ED")
    end

    def package_services
      Array(self[:package_services]).map do |service|
        {
          "SvcCode" => service
        }
      end
    end

    def package_number_checksum
      pn = package_number.chars.map(&:to_i)
      odd = pn.select.with_index { |_, i| i.odd? }.sum
      even = pn.select.with_index { |_, i| i.even? }.sum
      odd *= 3
      odd += even

      (10 - odd.to_s[-1].to_i) % 10
    end

    def to_xml
      {
        "MyApiPackageIn" => {
          "PackNumber" => package_number,
          "PackProductType" => package_product_type,
          "Weight" => weight,
          "Note" => note,
          "DepoCode" => depo_code,
          "Sender" => sender&.to_xml,
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
