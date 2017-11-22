# frozen_string_literal: true

require 'spec_helper'

RSpec.describe HarvestOvertime do
  let(:harvest_client) { instance_double(HarvestClient) }
  let(:business_days_computer) { instance_double(BusinessDaysComputer) }

  let(:harvest_overtime) do
    described_class.new(harvest_client: harvest_client, business_days_computer: business_days_computer)
  end

  describe '#monthly_stats' do
    let(:start_date) { Date.new(2017, 11, 29) }
    let(:end_date) { Date.new(2017, 12, 5) }

    subject { harvest_overtime.monthly_stats(start_date, end_date) }

    let(:time_entries) do
      [
        TimeEntry.new(
          Date.new(2017, 11, 29), 3
        ),
        TimeEntry.new(
          Date.new(2017, 11, 30), 5
        ),
        TimeEntry.new(
          Date.new(2017, 12, 4), 6
        ),
        TimeEntry.new(
          Date.new(2017, 12, 5), 8
        )
      ]
    end

    let(:business_days) do
      [
        Date.new(2017, 11, 29),
        Date.new(2017, 11, 30),
        Date.new(2017, 12, 1),
        Date.new(2017, 12, 4),
        Date.new(2017, 12, 5)
      ]
    end

    it 'returns stats grouped by month' do
      expect(harvest_client).to receive(:time_entries).with(start_date, end_date).and_return(time_entries)
      expect(business_days_computer).to receive(:business_days).with(start_date, end_date).and_return(business_days)

      expect(subject).to eq(Month.new(2017, 11) => TimeStats.new(16, 8),
                            Month.new(2017, 12) => TimeStats.new(24, 14))
    end
  end
end
