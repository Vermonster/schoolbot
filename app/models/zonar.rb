class Zonar
  STATIC_PARAMS = {
    action: 'showposition',
    operation: 'path',
    format: 'csv',
    version: 2,
    logvers: 3.5,
    type: 'Standard',
    reqtype: 'fleet'
  }

  CSV_HEADERS = {
    bus_identifier: 'Asset No.',
    latitude: 'Lat',
    longitude: 'Lon',
    distance: 'Distance Traveled(Miles)',
    heading: 'Heading',
    speed: 'Speed(MPH)',
    acceleration: 'Acceleration(Miles/Hour/Sec)',
    reason: 'Log Reason',
    zone: 'Zone'
  }

  TIME_HEADER_PATTERN = /^Time\(([A-Z]+)\)$/

  READ_TIMEOUT = 5.seconds
  REQUEST_INTERVAL = 20.seconds
  MAX_REQUEST_WINDOW = 2.minutes
  CIRCUIT_RETRY_INTERVAL = 1.minute

  def initialize(customer:, username:, password:)
    @credentials = {
      customer: customer,
      username: username,
      password: password
    }
  end

  def bus_events_since(start_time)
    clamped_start_time = [start_time, MAX_REQUEST_WINDOW.ago].compact.max

    csv_events = begin
      breaker.run do
        csv_events_between(clamped_start_time, Time.zone.now)
      end
    rescue CB2::BreakerOpen
      raise CB2::BreakerOpen, "Zonar customer: #{@credentials[:customer]}"
    end

    csv_to_attributes(csv_events)
  end

  private

  def breaker
    @_breaker ||= CB2::Breaker.new(
      service: "zonar-#{@credentials[:customer]}",
      duration: MAX_REQUEST_WINDOW.to_i,
      threshold: 100,
      reenable_after: CIRCUIT_RETRY_INTERVAL.to_i,
      redis: $redis
    )
  end

  # https://docs.zonarsystems.net/manuals/OMI/en/exportpath.html
  def csv_events_between(start_time, end_time)
    RestClient::Request.execute(
      method: :get,
      url: "https://#{@credentials[:customer]}.zonarsystems.net/interface.php",
      # https://github.com/rest-client/rest-client#passing-advanced-options
      headers: { params:
        STATIC_PARAMS.merge(starttime: start_time.to_i, endtime: end_time.to_i)
      },
      cookies: authentication_params,
      timeout: READ_TIMEOUT.to_i
    )
  end

  def authentication_params
    {
      username: @credentials[:username],
      password: @credentials[:password]
    }
  end

  def csv_to_attributes(csv_string)
    csv_rows = CSV.parse(csv_string, headers: true)

    if csv_rows.any?
      time_header = csv_rows.headers.grep(TIME_HEADER_PATTERN).first
      time_zone = time_header[TIME_HEADER_PATTERN, 1]

      csv_rows.map do |row|
        row_to_attributes(row, time_header: time_header, time_zone: time_zone)
      end
    else
      []
    end
  end

  def row_to_attributes(csv_row, time_header:, time_zone:)
    CSV_HEADERS.map { |attrib, header| [attrib, csv_row[header]] }.to_h.merge(
      recorded_at: Time.zone.parse(
        "#{csv_row['Date']} #{csv_row[time_header]} #{time_zone}"
      )
    )
  end
end
