module Ppl
  PalletInfo = Struct.new(
    :collies,
    :manipulation_type,
    :pallet_eur_count,
    :pack_description,
    :pick_up_cargo_type_code,
    :volume,
    keyword_init: true
  ) do
    def to_xml
      {
        "Collies" => {
          "MyApiPackageInColli" => collies.map(&:to_xml)
        },
        "ManipulationType" => manipulation_type,
        "PEURCount" => pallet_eur_count,
        "PackDesc" => pack_description,
        "PickUpCargoTypeCode" => pick_up_cargo_type_code,
        "Volume" => volume
      }
    end
  end
end
