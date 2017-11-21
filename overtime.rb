require 'faraday'
require 'json'
require 'date'
require 'active_support/time'

ACCOUNT_ID = ENV['HARVEST_ACCOUNT_ID']
TOKEN = ENV['HARVEST_TOKEN']
NUMBER_OF_MONTHS = 6

Month = Struct.new(:year, :month) do
  def self.from_date(date)
    new(date.year, date.month)
  end

  def to_s
    "#{year}-#{month.to_s.rjust(2, '0')}"
  end
end

TimeEntry = Struct.new(:date, :hours) do
  def month
    Month.new(date.year, date.month)
  end
end

MonthStats = Struct.new(:month, :business_hours, :billed_hours) do
  def overtime
    billed_hours - business_hours
  end
end

class HarvestClient
  def initialize(account_id:, personal_access_token:)
    @faraday = Faraday.new(
      url: 'https://api.harvestapp.com/api/v2',
      headers: { 'Harvest-Account-ID' => account_id, 'Authorization' => "Bearer #{personal_access_token}" }
    )
  end

  def time_entries(from_date, to_date)
    entries = []

    print 'Retrieving data .'
    response = faraday.get('time_entries', from: from_date.iso8601, to: to_date.iso8601)
    body_hash = parse_response(response)
    entries.concat(body_hash['time_entries'])

    while (next_page_url = body_hash.dig('links', 'next'))
      print '.'
      response = faraday.get(next_page_url)
      body_hash = parse_response(response)
      entries.concat(body_hash['time_entries'])
    end
    puts
    puts

    entries.map do |e|
      date = Date.parse(e['spent_date'])
      hours = e['hours']

      TimeEntry.new(date, hours)
    end
  end

  private

  attr_reader :faraday

  def parse_response(response)
    raise "REQUEST ERROR: #{response.body}" unless response.success?

    JSON.parse(response.body)
  end
end

client = HarvestClient.new(account_id: ACCOUNT_ID, personal_access_token: TOKEN)

to_date = Date.today
from_date = (to_date - (NUMBER_OF_MONTHS - 1).months).beginning_of_month

business_days = (from_date..to_date).reject(&:saturday?).reject(&:sunday?)
business_days_by_month = business_days.group_by { |date| Month.from_date(date) }

all_time_entries = client.time_entries(from_date, to_date)
non_zero_entries = all_time_entries.select { |e| e.hours > 0 }.reverse

stats = []

non_zero_entries.group_by { |entry| Month.from_date(entry.date) }.each do |month, entries|
  business_hours = business_days_by_month[month].size * 8
  billed_hours = entries.map(&:hours).reduce(&:+)

  stats << MonthStats.new(month, business_hours, billed_hours)
end

puts ['Month', 'Business hours', 'Billed hours', 'Overtime'].join("\t")
stats.each do |s|
  puts [
         s.month,
         s.business_hours,
         s.billed_hours.round(1),
         s.overtime.round(1)
       ].join("\t")
end

overtime = stats.map(&:overtime).reduce(&:+)
puts "\nTotal overtime: #{overtime.round(1)} hour(s) -> #{(overtime / 8).floor} day(s)"
