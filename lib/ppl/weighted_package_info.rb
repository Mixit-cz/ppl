module Ppl
  Route = Struct.new(
    :route_type,
    :route_code,
    keyword_init: true
  ) do
    def to_xml
      to_h.deep_transform_keys! { |key| key.to_s.camelcase }
    end
  end

  WeightedPackageInfo = Struct.new(
    :routes,
    :weight,
    keyword_init: true
  ) do
    def to_xml
      {
        "Weight" => weight,
        "Routes" => {
          "Route" => routes.map(&:to_xml)
        }
      }
    end
  end
end
