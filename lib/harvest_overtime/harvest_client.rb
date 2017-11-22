# frozen_string_literal: true

require 'faraday'
require 'json'

class HarvestClient
  def initialize(account_id:, personal_access_token:)
    @faraday = Faraday.new(
      url: 'https://api.harvestapp.com/api/v2',
      headers: { 'Harvest-Account-ID' => account_id, 'Authorization' => "Bearer #{personal_access_token}" }
    )
  end

  def time_entries(start_date, end_date)
    user_id = retrieve_user_id

    time_entry_hashes = retrieve_time_entries(user_id, start_date, end_date)

    build_time_entry_objects(time_entry_hashes)
  end

  private

  attr_reader :faraday

  def retrieve_user_id
    response = faraday.get('users/me')

    response_body_hash = parse_response(response)

    response_body_hash['id']
  end

  def retrieve_time_entries(user_id, start_date, end_date)
    time_entry_hashes = []

    response = faraday.get('time_entries', user_id: user_id, from: start_date.iso8601, to: end_date.iso8601)
    body_hash = parse_response(response)
    time_entry_hashes.concat(body_hash['time_entries'])

    while (next_page_url = body_hash.dig('links', 'next'))
      response = faraday.get(next_page_url)
      body_hash = parse_response(response)
      time_entry_hashes.concat(body_hash['time_entries'])
    end

    time_entry_hashes
  end

  def parse_response(response)
    raise "Harvest API request error (status #{response.code}): #{response.body}" unless response.success?

    JSON.parse(response.body)
  end

  def build_time_entry_objects(time_entry_hashes)
    time_entry_hashes.map do |time_entry_hash|
      date = Date.parse(time_entry_hash['spent_date'])
      hours = time_entry_hash['hours']

      TimeEntry.new(date, hours)
    end
  end
end
