module Ppl
  ExternalNumber = Struct.new(
    :code,
    :external_number,
    keyword_init: true
  ) do
    def initialize(*args)
      super(*args)

      %i(code external_number).each do |attribute|
        unless self[attribute].present?
          raise Ppl::Errors::AttributeRequired, "#{attribute} is required."
        end
      end
    end

    def to_xml
      {
        "Code" => code,
        "ExtNumber" => external_number
      }
    end
  end
end
