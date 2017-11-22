# frozen_string_literal: true

require 'harvest_overtime'

require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures'
  config.hook_into :faraday
end
