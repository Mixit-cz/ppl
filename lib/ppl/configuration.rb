module Ppl
  class Configuration
    attr_accessor :debug
    attr_writer :wsdl_url, :password, :username

    def initialize
      @wsdl_url = "https://myapi.ppl.cz/MyApi.svc?singleWsdl"
      @username = nil
      @password = nil
      @debug = true
    end

    def wsdl_url
      raise Errors::Configuration, "WSDL URL missing!" unless @wsdl_url
      @wsdl_url
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
