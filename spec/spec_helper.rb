require "bundler/setup"
require "ppl"

ENV["PPL_PASSWORD"] ||= ""
ENV["PPL_USERNAME"] ||= ""
ENV["PPL_WSDL_URL"] ||= "https://myapi.ppl.cz/MyApi.svc?singleWsdl"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:all) do
    Ppl.configure do |config|
      config.password = ENV["PPL_PASSWORD"]
      config.username = ENV["PPL_USERNAME"]
      config.wsdl_url = ENV["PPL_WSDL_URL"]
    end
  end
end
