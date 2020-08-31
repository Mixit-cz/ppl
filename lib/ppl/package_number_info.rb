module Ppl
  PackageNumberInfo = Struct.new(
    :series_number_id,
    :product_type,
    :depo_code,
    :is_cod,
    keyword_init: true
  ) do
    def cod?
      Product::CASH_ON_DELIVERY.include?(product_type)
    end

    def product_type_identifier
      case product_type
      when Product::PRIVATE_PALETTE, Product::PRIVATE_PALETTE_COD
        5
      when Product::PPL_PARCEL_CZ_PRIVATE, Product::PPL_PARCEL_CZ_PRIVATE_COD
        4
      when Product::COMPANY_PALETTE, Product::COMPANY_PALETTE_COD
        9
      when Product::PPL_PARCEL_CZ_BUSINESS, Product::PPL_PARCEL_CZ_BUSINESS_COD
        8
      when Product::EXPORT_PACKAGE, Product::EXPORT_PACKAGE_COD, Product::PPL_PARCEL_CONNECT, Product::PPL_PARCEL_CONNECT_COD
        2
      when Product::PPL_PARCEL_CZ_AFTERNOON_PACKAGE, Product::PPL_PARCEL_CZ_AFTERNOON_PACKAGE_COD
        3
      else
        raise Errors::Error, "Unknown package product type #{product_type}."
      end
    end
  end
end
