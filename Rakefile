# frozen_string_literal: true

require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*.rb'
end

require 'rubocop/rake_task'

RuboCop::RakeTask.new do |task|
  task.options = %w[--display-cop-names --format simple]
end

task default: %w[spec rubocop:auto_correct]
