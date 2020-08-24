module Ppl
  class Client
    attr_accessor :client

    def initialize
      @client = Savon.client(
        wsdl: Ppl.configuration.wsdl_url,
        log: Ppl.configuration.debug,
        log_level: :debug,
        pretty_print_xml: true,
        soap_version: 1,
        namespace_identifier: 'v1',
        env_namespace: 'soapenv',
        namespaces: {
          "xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/",
          "xmlns:v1" => "http://myapi.ppl.cz/v1"
        }
      )
    end

    def is_healthy
      operation(:is_healtly, {})
    end

    def login
      operation(
        :login,
        auth: {
          cust_id: Ppl.configuration.customer_id,
          user_name: Ppl.configuration.username,
          password: Ppl.configuration.password
        }
      )
    end

    def method_missing(m, *args, &block)
      operation(m, *args)
    end

    def operation(action, **params)
      request = @client.call(
        action,
        soap_action: "http://myapi.ppl.cz/v1/IMyApi2/#{action.to_s.camelcase}",
        message: process_params(params)
      )
      handle_response(request)
    end

    private

    def handle_response(request)
      case request.http.code
      when 200..299
        request.body
      else
        raise Ppl::Error, request.body
      end
    end

    def process_params(params)
      params.deep_transform_keys { |key| key.to_s.camelcase }
    end
  end
end
