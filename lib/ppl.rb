require "active_support"
require "active_support/core_ext/hash/keys"
require "active_support/core_ext/numeric/time"
require "active_support/core_ext/string/inflections"
require "savon"
require "zache"

require "ppl/configuration"
require "ppl/errors"
require "ppl/client"
require "ppl/enum/product"
require "ppl/enum/depo"
require "ppl/package"
require "ppl/package_number_info"
require "ppl/zpl_label"
require "ppl/address"
require "ppl/special_delivery"
require "ppl/payment_info"
require "ppl/order"
require "ppl/pickup_order"
require "ppl/external_number"
require "ppl/flag"
require "ppl/colli"
require "ppl/pallet_info"
require "ppl/number_range"
require "ppl/weighted_package_info"
require "ppl/version"

module Ppl
  class Error < StandardError; end

  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
