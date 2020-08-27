module Ppl
  Colli = Struct.new(
    :colli_number,
    :height,
    :length,
    :weight,
    :width,
    :wrap_code,
    keyword_init: true
  ) do
    def to_xml
      {
        "ColliNumber" => colli_number,
        "Height" => height,
        "Length" => length,
        "Weight" => weight,
        "Width" => width,
        "WrapCode" => wrap_code
      }
    end
  end
end
