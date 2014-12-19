require 'rubygems'
require 'bundler/setup'
require 'vcr'
require 'webmock'
require 'httparty'
require 'pry'
require 'zype'

RSpec.configure do |config|
  config.before(:suite) do
    # Set up Zype Environment the way you want (currently pointing to a dev property,
    # since it makes calls to the Zype API)
    Zype.configuration.api_key = 'D1Ds5oSPvEoLM8UefkuKfg'
    Zype.configuration.use_ssl = false
    Zype.configuration.port = 3000
    Zype.configuration.host = 'api.zype-core.com'
  end
end


# To re-record Cassettes, delete the cassets in support/vcr_cassettes
VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/support/vcr_cassettes'
  c.configure_rspec_metadata!
  c.default_cassette_options = {:record => :new_episodes}
end
