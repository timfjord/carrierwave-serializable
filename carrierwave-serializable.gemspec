# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'carrierwave-serializable/version'

Gem::Specification.new do |gem|
  gem.name          = 'carrierwave-serializable'
  gem.version       = CarrierWave::Serializable::VERSION
  gem.authors       = ['Tim Masliuchenko']
  gem.email         = ['timfjord@hey.com']
  gem.description   = %q{Carrierwave plugin that allow mount uploader to serialized field}
  gem.summary       = %q{Carrierwave plugin that allow mount uploader to serialized field}
  gem.homepage      = 'https://github.com/timfjord/carrierwave-serializable'
  gem.licenses      = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'carrierwave'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
end
