# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ups_pickup/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["amardaxini"]
  gem.email         = ["amardaxini@gmail.com"]
  gem.description   = %q{UPS Pickup Request API}
  gem.summary       = %q{UPS Pickup Request API}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "ups_pickup"
  gem.require_paths = ["lib"]
  gem.version       = UpsPickup::VERSION
  gem.add_dependency('httparty')
  gem.add_dependency('savon', '~> 2.4.0')

end
