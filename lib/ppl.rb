require "active_support"
require "active_support/core_ext/hash/keys"
require "active_support/core_ext/string/inflections"
require "savon"

require "ppl/configuration"
require "ppl/errors"
require "ppl/client"
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
