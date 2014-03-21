Gem::Specification.new do |s|
  s.name        = 'zype-cli'
  s.version     = '0.0.0'
  s.date        = '2014-03-20'
  s.summary     = "Command line interface to interact with Zype API"
  s.authors     = ["Brian Dorry"]
  s.email       = 'bdorry@zypemedia.com'
  s.homepage    =
    'http://rubygems.org/gems/zype-cli'
  s.license       = 'MIT'
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "lib/zype-cli.rb",
    "lib/zype-cli/client.rb",
    "lib/zype-cli/collection.rb",
    "lib/zype-cli/model.rb",    
    "lib/zype-cli/models/zobject_schema.rb",
    "lib/zype-cli/models/zobject_schemas.rb",
    "lib/zype-cli/models/zobject.rb",
    "lib/zype-cli/models/zobjects.rb"    
  ]

end
