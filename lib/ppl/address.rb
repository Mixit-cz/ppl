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
end
