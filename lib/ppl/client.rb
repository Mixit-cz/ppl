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
      )&.dig(:auth_token)
    end

    %i(get_parcel_shops get_cities_routing get_packages).each do |m|
      define_method(m) do |**filter|
        operation(m, filter: filter)&.dig(:result_data)
      end
    end

    def create_orders(orders)
      operation(:create_orders, orders: orders.map(&:to_xml))&.dig(:result_data)
    end

    def create_pickup_orders(pickup_orders)
      operation(:create_pickup_orders, orders: pickup_orders.map(&:to_xml))&.dig(:result_data)
    end

    def create_packages(packages, customer_unique_import_id = nil)
      operation(
        :create_packages,
        customer_unique_import_id: customer_unique_import_id,
        packages: packages.map(&:to_xml)
      )&.dig(:result_data)
    end

    def get_sprint_routes
      super.dig(:result_data, :my_api_sprint_routes)
    end

    def get_number_range(number_ranges)
      operation(:get_number_range, number_ranges: number_ranges.map(&:to_xml))&.dig(:result_data)
    end

    def generate_package_number(package_number_info)
      identifier = [
        package_number_info.product_type_identifier,
        package_number_info.depo_code,
        package_number_info.cod? ? "9" : "5",
        package_number_info.series_number_id.ljust(7, "0")
      ].join

      unless identifier.length == 11
        raise Errors::Error, "Failed to generate correct package ID: #{identifier}"
      end

      identifier
    end

    def method_missing(m, *args, &block)
      operation(m, *args)
    end

    private

    def auth_token
      @cache.get(:auth_token, lifetime: 30 * 60) { login }
    end

    def handle_response(response, action)
      path = ["#{action}_response".to_sym, "#{action}_result".to_sym]

      if BUSINESS_METHODS.include?(action)
        save_auth_token(response.body.dig(*(path + [:auth_token])))
      end

      response.body.dig(*path)
    rescue Savon::Error => e
      raise Ppl::Error, e.message
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

    def process_params(params)
      params.deep_transform_keys { |key| key.to_s.camelcase }
    end

    def save_auth_token(token)
      @cache.put(:auth_token, token, lifetime: 30 * 60)
    end
  end
end
