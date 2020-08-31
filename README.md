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

### Create pickup orders

```ruby
client = Ppl::Client.new
pickup_order = Ppl::PickupOrder.new(packages_count: 1, order_reference_id: order_reference_id, send_date: "2020-09-01", sender: sender)
client.create_pickup_orders([pickup_order])
```

### Get cities routing

```ruby
client = Ppl::Client.new
client.get_cities_routing(country_code: "CZ")
# => {:my_api_city_routing=>
#  [{:changed=>#<DateTime: 2018-09-06T14:04:34+00:00 ((2458368j,50674s,343000000n),+0s,2299161j)>,
#    :city=>"Depo02",
#    :country_code=>"CZ ",
#    :created=>#<DateTime: 2018-02-02T12:35:23+00:00 ((2458152j,45323s,70000000n),+0s,2299161j)>,
#    :depo_code=>"02",
#    :highlighted=>false,
#    :post=>"České Budějovice",
#    :region=>nil,
#    :reject=>false,
#    :route_code=>"02899",
#    :services=>
#     {:my_api_city_route_svc=>
#       [{:code=>"SAT", :value=>true}, {:code=>"ED", :value=>false}, {:code=>"MD", :value=>false}]},
#    :street=>nil,
#    :zip_code=>"02999"},…
```

### Get packages

```ruby
client = Ppl::Client.new
client.get_packages(date_from: "2020-08-30", date_to: "2020-09-01")
# => {:my_api_package_out=>
#  [{:back_date=>nil,
#    :back_pack_number=>nil,
#    :back_pack_number_active=>nil,
#    :backed_doc=>nil,
#    :deliv_date=>#<DateTime: 2020-xxxxx+00:00>,
#    :deliv_person=>"xxx",
#    :delivery_to_ktm=>false,
#    :dep_in_code=>"01",
#    :dep_in_name=>"Depo Jažlovice",
#    :dep_out_code=>"01",
#    :dep_out_name=>"Depo Jažlovice",
#    :depo_code=>nil,…
```

### ZPL labels

```ruby
client = Ppl::Client.new
recipient = Ppl::Address.new(name: "John Doe", email: "john.doe@example.com", city: "Praha", country: "CZ", street: "Ohradní 65", phone: "777123456", zip_code: "14000")
sender = Ppl::Address.new(name: "Mixit s.r.o.", email: "mixit@mix.it", city: "Praha", country: "CZ", street: "Ohradní 65", phone: "777123456", zip_code: "14000")

# Generate package number:
package_number_info = Ppl::PackageNumberInfo.new(series_number_id: "114", product_type: Ppl::Product::PPL_PARCEL_CZ_PRIVATE, depo_code: Ppl::Depo::CODE_01)
package_number = client.generate_package_number(package_number_info)
# => "40151140000"

payment_info = Ppl::PaymentInfo.new(cash_on_delivery_price: 300, cash_on_delivery_currency: "CZK")

package = Ppl::Package.new(package_number: package_number, package_product_type: Ppl::Product::PPL_PARCEL_CZ_PRIVATE, weight: 1.44, note: "Test", recipient: recipient, sender: sender, package_position: "1", payment_info: payment_info, package_count: 1)
zpl_label = Ppl::ZplLabel.new([package])
zpl_label.raw_zpl
# => => "^XA^MUM^LH2,2^FS^LL^PW^PON^FO47,49^LRY^GB48,80,0.3,B,0^FS^FO13,49^LRY^GB28,80,0.3,B,0^FS^FO4.7,114^LRY^GB6,15,0.3,B,0^FS^FO47.2,107.7^LRY^GB21,21,10.5,B,0^FS^FO88,7^GFA,2520,2520,9…
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Mixit-cz/ppl.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
