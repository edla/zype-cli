Gem::Specification.new do |s|
  s.name        = 'zype'
  s.version     = '0.0.0'
  s.date        = '2014-03-20'
  s.summary     = "Zype Platform Client/CLI"
  s.description = "Client library and CLI to interact with the Zype Platform API"
  s.authors     = ["Brian Dorry"]
  s.email       = 'bdorry@zypemedia.com'
  s.homepage    =
    'http://rubygems.org/gems/zype'
  s.license       = 'MIT'

  s.files = `git ls-files`.split("\n")

  s.executables = [
    "zype"
  ]

  s.add_dependency('aws-sdk', '~> 1.50')
  s.add_dependency('multi_json', '~> 1.9')
  s.add_dependency('hashie', '~> 2.0')
  s.add_dependency('thor', '~> 0.19')
  s.add_dependency('rainbow', '~> 2.0')
  s.add_dependency('hirb', '~> 0.7')
end
