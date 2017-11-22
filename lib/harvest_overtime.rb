# frozen_string_literal: true

require 'date'

require_relative 'harvest_overtime/structs'
require_relative 'harvest_overtime/business_days_computer'
require_relative 'harvest_overtime/harvest_client'

class HarvestOvertime
  HOURS_PER_DAY = 8

  def initialize(account_id: nil, personal_access_token: nil, harvest_client: nil, business_days_computer: nil)
    @business_days_computer = business_days_computer || BusinessDaysComputer.new
    @harvest_client = harvest_client || build_default_harvest_client(account_id, personal_access_token)
  end

  def monthly_stats(start_date, end_date)
    business_days = business_days_computer.business_days(start_date, end_date)
    business_hours_number_by_month = compute_per_month_business_hours_number(business_days)

    time_entries = harvest_client.time_entries(start_date, end_date)
    billed_hours_by_month = sum_billed_hours_by_month(time_entries)

    business_hours_number_by_month.each_with_object({}) do |(month, business_hours), hash|
      billed_hours = billed_hours_by_month[month] || 0

      hash[month] = TimeStats.new(business_hours, billed_hours)
    end
  end

  private

  attr_reader :business_days_computer, :harvest_client

  def build_default_harvest_client(account_id, personal_access_token)
    raise ArgumentError, 'account_id must be provided' unless account_id
    raise ArgumentError, 'personal_access_token must be provided' unless personal_access_token

    HarvestClient.new(account_id: account_id, personal_access_token: personal_access_token)
  end

  def compute_per_month_business_hours_number(business_days)
    business_days.each_with_object({}) do |date, hash|
      month = Month.from_date(date)

      hash[month] ||= 0
      hash[month] += HOURS_PER_DAY
    end
  end

  def sum_billed_hours_by_month(time_entries)
    time_entries.each_with_object({}) do |entry, hash|
      month = Month.from_date(entry.date)

      hash[month] ||= 0
      hash[month] += entry.hours
    end
  end
end
