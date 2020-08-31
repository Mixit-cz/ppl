# PPL's MyApi Ruby gem

Gem for interacting with PPL's MyApi.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ppl'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ppl

## Configuration

Create an initializer in `config/initializers/ppl.rb` with following content:

```ruby
Ppl.configure do |config|
  config.customer_id = "Your customer ID (only digits)"
  config.username = "Your API username"
  config.password = "Your API password"
end
```

## Usage

### Check API status

```ruby
client = Ppl::Client.new
client.is_healthy
# => "Healthy"
```

### Get API version

```ruby
client = Ppl::Client.new
client.version
# => "1.20.820.1359"
```

### Get parcel shops

```ruby
client = Ppl::Client.new
client.get_parcel_shops(country_code: "CZ")
# => {:my_api_parcel_shop=>
#  [{:city=>"Liberec",
#    :country=>"CZ ",
#    :email=>nil,
#    :fax=>nil,
#    :gps_location=>
#     {:gps_e_d=>"15", :gps_e_m=>"3", :gps_e_s=>"52.9920", :gps_n_d=>"50", :gps_n_m=>"45", :gps_n_s=>"2.0160"},
#    :name=>"Žabka - Liberec",
#    :name2=>"PPL Parcelshop 102",
#    :org_id=>"29046645",
#    :org_vat_id=>"CZ29046645",
#    :parcel_shop_code=>"KM10246006",
#    :parcel_shop_note=>
#     "Upozorňujeme, že služby podej zásilek za hotové, podej zásilek s etiketou a return service v provozovnách sítě Žabka nejsou možné.",
#    :phone=>nil,
#    :position=>nil,
#    :qr_code=>nil,
#    :street=>"Ježkova 955",
#    :work_hours=>
#     {:my_api_ktm_work_hour=>
#       [{:day=>"1", :from=>"06:00", :to=>"12:00"},
#        {:day=>"1", :from=>"12:00", :to=>"23:00"},
#        {:day=>"2", :from=>"06:00", :to=>"12:00"},
#        {:day=>"2", :from=>"12:00", :to=>"23:00"},
#        {:day=>"3", :from=>"06:00", :to=>"12:00"},
#        {:day=>"3", :from=>"12:00", :to=>"23:00"},
#        {:day=>"4", :from=>"06:00", :to=>"12:00"},
#        {:day=>"4", :from=>"12:00", :to=>"23:00"},
#        {:day=>"5", :from=>"06:00", :to=>"12:00"},
#        {:day=>"5", :from=>"12:00", :to=>"23:00"},
#        {:day=>"6", :from=>"06:00", :to=>"12:00"},
#        {:day=>"6", :from=>"12:00", :to=>"23:00"},
#        {:day=>"7", :from=>"06:00", :to=>"12:00"},
#        {:day=>"7", :from=>"12:00", :to=>"23:00"}]},
#    :zip_code=>"46006"},…
```

### Get sprint routes

```ruby
client = Ppl::Client.new
client.get_sprint_routes
# => [{:zip_from=>"10000", :zip_to=>"10999", :delivery_depot=>"PRG", :delivery_region=>"AB", :sort_code=>"P10"},
# {:zip_from=>"11000", :zip_to=>"11999", :delivery_depot=>"PRG", :delivery_region=>"AB", :sort_code=>"P01"},
# {:zip_from=>"12000", :zip_to=>"12999", :delivery_depot=>"PRG", :delivery_region=>"AB", :sort_code=>"P02"},
# {:zip_from=>"13000", :zip_to=>"13999", :delivery_depot=>"PRG", :delivery_region=>"AB", :sort_code=>"P03"},…
```

### Get number range

```ruby
client = Ppl::Client.new
number_range = Ppl::NumberRange.new(product_type: "CL", quantity: 100)
client.get_number_range([number_range])
# => {:number_range=>
#    {:pack_product_type=>"CL",
#     :name=>nil,
#     :quantity=>"100",
#     :from=>"JD0000400400001311841",
#     :to=>"JD0000400400001311940",
#     :error_code=>"0",
#     :error_message=>nil}}
```

### Create packages

```ruby
client = Ppl::Client.new
recipient = Ppl::Address.new(name: "John Doe", email: "john.doe@example.com", city: "Praha", country: "CZ", street: "Ohradní 65", phone: "777123456", zip_code: "14000")

# Generate package number:
package_number_info = Ppl::PackageNumberInfo.new(series_number_id: "114", product_type: Ppl::Product::PPL_PARCEL_CZ_PRIVATE, depo_code: Ppl::Depo::CODE_01)
package_number = client.generate_package_number(package_number_info)
# => "40151140000"

package = Ppl::Package.new(package_number: package_number, package_product_type: Ppl::Product::PPL_PARCEL_CZ_PRIVATE, weight: 1.44, note: "Test", recipient: recipient)
client.create_packages([package])
```

### Create orders

```ruby
client = Ppl::Client.new
order = Ppl::Order.new(packages_count: 1, order_reference_id: order_reference_id, package_product_type: Ppl::Product::PPL_PARCEL_CZ_BUSINESS, send_date: "2020-09-01", sender: sender, recipient: recipient)
client.create_orders([order])
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Mixit-cz/ppl.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
