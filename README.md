# Zype-CLI

## How to install

1. Build gem

`gem build zype.gemspec`

2. Install gem

`gem install ./zype-1.0.0.gem`

## How to use

1. Open irb

`irb`

2. Require gem

`require 'zype'`

3. Configure gem

#### For a rails application add the following under: config/initializers/zype.rb

```ruby
Zype.configure do |config|
  config.api_key = [your api key]
  config.host    = [host] # default: api.zype-core.com
  config.port    = [port] # default: 3000
  config.use_ssl = false  # default: false
end
```

4. Create a client

`Zype::Client.new`

5. Query zobjects

`client.zobjects.all(zobject: 'team')`

## To Test

1. Go to spec/spec_helper.rb and edit the Zype configurations where you want your
tests to query to.

2. Run `rspec spec`

3. API Queries are recorded in `spec/support/vcr_cassettes`. If you want fresh API queries,
delete the Zype directory of yml records and run your tests again!
