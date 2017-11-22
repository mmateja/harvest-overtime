# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BusinessDaysComputer do
  let(:computer) { described_class.new }

  describe '#business_days' do
    subject { computer.business_days(start_date, end_date) }

    let(:start_date) { Date.new(2017, 11, 22) }
    let(:end_date) { Date.new(2017, 11, 29) }

    it 'returns all days within range excluding weekends' do
      expect(subject).to eq([
                              Date.new(2017, 11, 22), # Wednesday
                              Date.new(2017, 11, 23), # Thursday
                              Date.new(2017, 11, 24), # Friday
                              Date.new(2017, 11, 27), # Monday
                              Date.new(2017, 11, 28), # Tuesday
                              Date.new(2017, 11, 29) # Wednesday
                            ])
    end
  end
end
