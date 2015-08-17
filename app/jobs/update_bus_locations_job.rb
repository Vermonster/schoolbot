class UpdateBusLocationsJob < ActiveJob::Base
  queue_as :default

  def perform(district)
    @district = district

    zonar.bus_events_since(last_event_time).each do |attributes|
      identifier = attributes.delete(:bus_identifier)
      bus = district.buses.find_or_create_by!(identifier: identifier)
      bus.bus_locations
        .find_or_initialize_by(recorded_at: attributes.delete(:recorded_at))
        .update!(attributes)
    end
  end

  private

  def last_event_time
    @district.bus_locations.maximum(:recorded_at)
  end

  def zonar
    Zonar.new(
      credentials: {
        customer: @district.zonar_customer,
        username: @district.zonar_username,
        password: @district.zonar_password
      }
    )
  end
end
