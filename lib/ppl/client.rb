module Ppl
  class Client
    BUSINESS_METHODS = %i(
      get_packages get_cities_routing create_orders create_packages
      create_pickup_orders get_number_range
    ).freeze

    attr_accessor :client

    def initialize
      @cache = Zache.new
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
          password: Ppl.configuration.password,
          user_name: Ppl.configuration.username
        }
      )&.dig(:login_response, :login_result, :auth_token)
    end

    def method_missing(m, *args, &block)
      operation(m, *args)
    end

    def operation(action, **params)
      if BUSINESS_METHODS.include?(action)
        auth = {
          auth: {
            auth_token: auth_token
          }
        }
      else
        auth = {}
      end

      response = @client.call(
        action,
        soap_action: "http://myapi.ppl.cz/v1/IMyApi2/#{action.to_s.camelcase}",
        message: process_params(auth.merge(params))
      )

      handle_response(response, action)
    end

    private

    def auth_token
      @cache.get(:auth_token, lifetime: 30 * 60) { login }
    end

    def handle_response(response, action)
      path = ["#{action}_response".to_sym, "#{action}_result".to_sym]

      if BUSINESS_METHODS.include?(action)
        save_auth_token(response.dig(path + :auth_token))
      end

      response.dig(path)
    rescue Savon::Error => e
      raise Ppl::Error, e.message
    end

    def process_params(params)
      params.deep_transform_keys { |key| key.to_s.camelcase }
    end

    def save_auth_token(token)
      @cache.put(:auth_token, token, lifetime: 30 * 60)
    end
  end
end
