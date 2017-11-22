# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name        = 'harvest_overtime'
  s.version     = '1.0.0'
  s.date        = '2017-11-22'
  s.summary     = 'Keep track of your billed hours in Harvest!'
  s.description = 'Simple command-line tool for tracking overtime in Harvest'
  s.author      = 'Marek Mateja'
  s.email       = 'matejowy@gmail.com'
  s.files       = %w[lib/harvest_overtime.rb lib/harvest_overtime/structs.rb lib/harvest_overtime/harvest_client.rb
                     lib/harvest_overtime/business_days_computer.rb]
  s.homepage    = 'https://github.com/mmateja/harvest_overtime'
  s.license     = 'ISC'

  s.required_ruby_version = '>= 2.3'

  s.executables << 'overtime'

  s.add_runtime_dependency 'faraday'
  s.add_runtime_dependency 'activesupport'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'rubocop'
end
