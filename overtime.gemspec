# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'harvest_overtime'
  s.version     = '1.0.1'
  s.date        = '2017-11-26'
  s.summary     = 'Keep track of your billed hours in Harvest!'
  s.description = 'Simple command-line tool for tracking overtime in Harvest'
  s.author      = 'Marek Mateja'
  s.email       = 'matejowy@gmail.com'
  s.homepage    = 'https://github.com/mmateja/harvest_overtime'
  s.license     = 'ISC'

  s.files = Dir['lib/**/*.rb']
  s.executables << 'overtime'

  s.required_ruby_version = '>= 2.3'

  s.add_runtime_dependency 'activesupport'
  s.add_runtime_dependency 'faraday'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'vcr'
end
