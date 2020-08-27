module Ppl
  SpecialDelivery = Struct.new(
    :parcel_shop_code,
    :delivery_date,
    :delivery_time_from,
    :delivery_time_to,
    :take_date,
    :take_time_from,
    :take_time_to,
    keyword_init: true
  ) do
    def initialize(*args)
      super(*args)

      unless take_date.present?
        raise Ppl::Errors::AttributeRequired, "take_date is required."
      end

      %i(
        delivery_date delivery_time_from delivery_time_to take_date
        take_time_from take_time_to
      ).each do |attribute|
        if self[attribute].present? && !self[attribute].is_a?(DateTime)
          self[attribute] = DateTime.parse(self[attribute])
        end
      end
    end

    def to_xml
      {
        "ParcelShopCode" => parcel_shop_code,
        "SpecDelivDate" => delivery_date.strftime("%F"),
        "SpecDelivDateFrom" => delivery_date_from.strftime("%T"),
        "SpecDelivDateTo" => delivery_date_to.strftime("%T"),
        "SpecTakeDate" => take_date.strftime("%F"),
        "SpecTakeDateFrom" => take_date_from.strftime("%T"),
        "SpecTakeDateTo" => take_date_to.strftime("%T")
      }
    end
  end
end
