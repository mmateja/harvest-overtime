# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Month do
  let(:year) { 2017 }
  let(:month) { 11 }

  let(:month_object) { described_class.new(year, month) }

  describe '#to_s' do
    subject { month_object.to_s }

    it 'returns string value' do
      expect(subject).to be_a(String)
    end

    it 'applies proper formatting' do
      expect(subject).to eq('2017-11')
    end

    describe 'month formatting' do
      let(:month) { 4 }

      it 'prints leading zeros' do
        expect(subject).to eq('2017-04')
      end
    end
  end
end
