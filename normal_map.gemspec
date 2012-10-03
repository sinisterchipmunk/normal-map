# -*- encoding: utf-8 -*-
require File.expand_path('../lib/normal_map/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Colin MacKenzie IV"]
  gem.email         = ["sinisterchipmunk@gmail.com"]
  gem.description   = %q{Generates DOT3 bump maps, also known as normal maps, for use in 3D computing.}
  gem.summary       = %q{Command line tool and Ruby library for generating normal maps.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "normal_map"
  gem.require_paths = ["lib"]
  gem.version       = NormalMap::VERSION
  gem.add_dependency 'thor'
  gem.add_dependency 'rmagick'
  gem.add_development_dependency 'rspec'
end
