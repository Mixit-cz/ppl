module Ppl
  NumberRange = Struct.new(
    :product_type,
    :quantity,
    :document_back,
    keyword_init: true
  ) do
    def initialize(*args)
      super(*args)

      %i(
        product_type quantity
      ).each do |attribute|
        unless self[attribute].present?
          raise Ppl::Errors::AttributeRequired, "#{attribute} is required."
        end
      end
    end

    def to_xml
      {
        "NumberRangeRequest" => {
          "PackProductType" => product_type,
          "Quantity" => quantity,
          "DocumentBack" => document_back || false
        }
      }
    end
  end
end
