class Zonar
  READ_TIMEOUT = 5

  STATIC_PARAMS = {
    action: 'showposition',
    operation: 'path',
    format: 'csv',
    version: 2,
    logvers: 3.5,
    type: 'Standard',
    reqtype: 'fleet',
    revgeocode: true
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
    zone: 'Zone',
    address: 'Address'
  }

  TIME_HEADER_PATTERN = /^Time\(([A-Z]+)\)$/

  def initialize(district)
    @district = district
  end

  def bus_events_since(time)
    csv_to_attributes(csv_events_between(time, Time.zone.now))
  end

  private

  # https://docs.zonarsystems.net/manuals/OMI/en/exportpath.html
  def csv_events_between(start_time, end_time)
    RestClient::Request.execute(
      method: :get,
      url: "https://#{@district.zonar_customer}.zonarsystems.net/interface.php",
      # https://github.com/rest-client/rest-client#passing-advanced-options
      headers: { params:
        STATIC_PARAMS.merge(starttime: start_time.to_i, endtime: end_time.to_i)
      },
      cookies: authentication_params,
      timeout: READ_TIMEOUT
    )
  end

  def authentication_params
    {
      username: @district.zonar_username,
      password: @district.zonar_password
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
