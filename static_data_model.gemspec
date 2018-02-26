# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'static_data_model/version'

Gem::Specification.new do |spec|
  spec.name          = 'static_data_model'
  spec.version       = StaticDataModel::VERSION
  spec.authors       = ['Sage GmbH']
  spec.email         = []

  spec.summary       = 'Some modules to give you tableless model behaviour in '\
                       'a class'
  spec.description   = 'Basic functionality for models to get initialised '\
                       'with static data and make them accessible with common '\
                       'finder methods'
  spec.homepage      = 'https://github.com/Sage/static_data_model'
  spec.license       = 'Apache 2.0'

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://mygemserver.com'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'activerecord'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
