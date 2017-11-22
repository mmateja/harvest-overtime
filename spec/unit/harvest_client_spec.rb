# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HarvestClient do
  let(:account_id) { '123456' }
  let(:personal_access_token) { 'HARVEST_ACCESS_TOKEN' }

  let(:client) { described_class.new(account_id: account_id, personal_access_token: personal_access_token) }

  describe '#time_entries' do
    let(:start_date) { Date.new(2017, 11, 10) }
    let(:end_date) { Date.new(2017, 11, 11) }

    subject { client.time_entries(start_date, end_date) }

    it 'downloads entries from Harvest API and converts them to TimeEntry objects' do
      VCR.use_cassette('receiving_user_time_entries') do
        expect(subject).to eq([
                                TimeEntry.new(Date.new(2017, 11, 10), 5.5),
                                TimeEntry.new(Date.new(2017, 11, 11), 8.0)
                              ])
      end
    end
  end
end
