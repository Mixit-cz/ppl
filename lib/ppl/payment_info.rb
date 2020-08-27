module Ppl
  PaymentInfo = Struct.new(
    :bank_account,
    :bank_code,
    :cash_on_delivery_currency,
    :cash_on_delivery_price,
    :cash_on_delivery_variable_symbol,
    :iban,
    :insurance_currency,
    :insurance_price,
    :specific_symbol,
    :swift,
    keyword_init: true
  ) do
    def to_xml
      {
        "BankAccount" => bank_account,
        "BankCode" => bank_code,
        "CodCurrency" => cash_on_delivery_currency,
        "CodPrice" => cash_on_delivery_price,
        "CodVarSym" => cash_on_delivery_variable_symbol,
        "IBAN" => iban,
        "InsurCurrency" => insurance_currency,
        "InsurPrice" => insurance_price,
        "SpecSymbol" => specific_symbol,
        "Swift" => swift
      }
    end
  end
end
