module Ppl
  Flag = Struct.new(
    :code,
    :value,
    keyword_init: true
  ) do
    def to_xml
      {
        "Code" => code,
        "Value" => value
      }
    end
  end
end
