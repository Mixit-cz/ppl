RSpec.describe Ppl::Configuration do
  context "with configuration block" do
    it "returns the correct WSDL URL" do
      expect(Ppl.configuration.wsdl_url).to eq(ENV["PPL_WSDL_URL"])
    end

    it "returns the correct password" do
      expect(Ppl.configuration.password).to eq(ENV["PPL_PASSWORD"])
    end

    it "returns the correct username" do
      expect(Ppl.configuration.username).to eq(ENV["PPL_USERNAME"])
    end

    it "returns the correct customer_id" do
      expect(Ppl.configuration.customer_id).to eq(ENV["PPL_CUSTOMER_ID"])
    end
  end

  context "without configuration block" do
    before do
      Ppl.reset
    end

    it "raises configuration error for missing password" do
      expect { Ppl.configuration.password }.to raise_error(Ppl::Errors::Configuration)
    end

    it "raises configuration error for missing username" do
      expect { Ppl.configuration.username }.to raise_error(Ppl::Errors::Configuration)
    end

    it "raises configuration error for missing customer_id" do
      expect { Ppl.configuration.customer_id }.to raise_error(Ppl::Errors::Configuration)
    end
  end
end
