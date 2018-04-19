# rubocop:disable Metrics/AbcSize

class SimulateBusLocationJob < ActiveJob::Base
  DISTANCE = 1 / 3437.670013352 # radius_of_circle/earth_radius in miles

  # These calculations simulate the bus driving around in a circle
  def perform(iteration)
    Bus.find_each do |bus|
      degree = convert_to_radians iteration
      bus_location = bus.bus_locations.first
      unless bus_location.nil?
        lat = convert_to_radians bus_location.latitude
        long = convert_to_radians bus_location.longitude

        new_latitude = convert_to_degrees(Math.asin(Math.sin(lat) * Math.cos(DISTANCE) + Math.cos(lat) * Math.sin(DISTANCE) * Math.cos(degree)))
        new_longitude = convert_to_degrees(long + Math.atan2(Math.sin(degree) * Math.sin(DISTANCE) * Math.cos(lat), Math.cos(DISTANCE) - Math.sin(lat) * Math.sin(new_latitude)))

        BusLocation.create(bus_id: bus.id, latitude: new_latitude,
                           heading: bus_location.heading, longitude: new_longitude, recorded_at: Time.now.in_time_zone
        )
      end
    end
  end

  private

  def convert_to_radians(degrees)
    degrees * Math::PI / 180
  end

  def convert_to_degrees(radians)
    radians * 180 / Math::PI
  end
end
# rubocop:enable Metrics/AbcSize
