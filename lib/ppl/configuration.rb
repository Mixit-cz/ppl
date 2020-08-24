module Ppl
  class Configuration
    attr_accessor :debug
    attr_writer :wsdl_url, :password, :username, :customer_id

    def initialize
      @wsdl_url = "https://myapi.ppl.cz/MyApi.svc?singleWsdl"
      @customer_id = ENV["PPL_CUSTOMER_ID"]
      @username = ENV["PPL_USERNAME"]
      @password = ENV["PPL_PASSWORD"]
      @debug = true
    end

    def wsdl_url
      raise Errors::Configuration, "WSDL URL missing!" unless @wsdl_url
      @wsdl_url
    end

    def customer_id
      raise Errors::Configuration, "Customer ID missing!" unless @customer_id
      @customer_id
    end

    def username
      raise Errors::Configuration, "Username missing!" unless @username
      @username
    end

    def password
      raise Errors::Configuration, "Password missing!" unless @password
      @password
    end
  end
end
