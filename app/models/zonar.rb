class Zonar
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

  MATCH_TIME_HEADER = /^Time\(([A-Z]+)\)$/

  def initialize(district)
    @district = district
  end

  def bus_events_since(time)
    csv_to_attributes(csv_events_between(time, Time.zone.now))
  end

  private

  # https://docs.zonarsystems.net/manuals/OMI/en/exportpath.html
  def csv_events_between(start_time, end_time)
    RestClient.get(
      "https://#{@district.zonar_customer}.zonarsystems.net/interface.php",
      params: STATIC_PARAMS.merge(
        starttime: start_time.to_i, endtime: end_time.to_i
      ),
      cookies: {
        username: @district.zonar_username,
        password: @district.zonar_password
      }
    )
  end

  def csv_to_attributes(csv_string)
    csv_rows = CSV.parse(csv_string, headers: true)
    time_header = csv_rows.headers.find { |header| header =~ MATCH_TIME_HEADER }
    time_zone = time_header[MATCH_TIME_HEADER, 1]

    csv_rows.map do |row|
      CSV_HEADERS.map { |attrib, header| [attrib, row[header]] }.to_h.merge(
        recorded_at: Time.zone.parse(
          "#{row['Date']} #{row[time_header]} #{time_zone}"
        )
      )
    end
  end
end
