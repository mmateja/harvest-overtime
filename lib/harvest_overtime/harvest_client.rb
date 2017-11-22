class HarvestClient
  def initialize(account_id:, personal_access_token:)
    @faraday = Faraday.new(
      url: 'https://api.harvestapp.com/api/v2',
      headers: { 'Harvest-Account-ID' => account_id, 'Authorization' => "Bearer #{personal_access_token}" }
    )
  end

  def time_entries(from_date, to_date)
    user_id = get_user_id

    entries = []

    print 'Retrieving data .'
    response = faraday.get('time_entries', user_id: user_id, from: from_date.iso8601, to: to_date.iso8601)
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

  def get_user_id
    response = faraday.get('users/me')

    response_body_hash = parse_response(response)

    response_body_hash['id']
  end

  def parse_response(response)
    raise "REQUEST ERROR: #{response.body}" unless response.success?

    JSON.parse(response.body)
  end
end
