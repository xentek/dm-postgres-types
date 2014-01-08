# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dm-postgres-types/version'

Gem::Specification.new do |gem|
  gem.name          = "dm-postgres-types"
  gem.version       = DataMapper::PostgresTypes::VERSION
  gem.authors       = ["Eric Marden"]
  gem.email         = ["eric@xentek.net"]
  gem.summary       = %q{Adds support for native PostgreSQL datatypes to DataMapper}
  gem.description   = %q{Adds support for native PostgreSQL datatypes, including JSON, HSTORE, and Array to DataMapper}
  gem.homepage      = ""
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'dm-core', '~> 1.2.0'
  gem.add_dependency 'dm-migrations', '~> 1.2.0'
  gem.add_dependency 'dm-types', '~> 1.2.0'
  gem.add_dependency 'dm-validations', '~> 1.2.0'
  gem.add_dependency 'dm-postgres-adapter', '~> 1.2.0'
  gem.add_dependency 'oj'

  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'gem-release'
end
