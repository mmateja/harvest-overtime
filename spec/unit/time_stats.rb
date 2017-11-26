# frozen_string_literal: true

require 'spec_helper'

RSpec.describe TimeStats do
  let(:business_hours) { 16 }
  let(:billed_hours) { 14.5 }

  let(:stats) { described_class.new(business_hours, billed_hours) }

  describe '#overtime' do
    subject { stats.overtime }

    it 'returns difference between business and actually billed hours' do
      expect(subject.round(1)).to eq(-1.5.round(1))
    end
  end
end
