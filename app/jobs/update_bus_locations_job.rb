class UpdateBusLocationsJob < ActiveJob::Base
  queue_as :default

  def perform(district, since:)
    Zonar.new(district).bus_events_since(since).each do |attributes|
      identifier = attributes.delete(:bus_identifier)
      bus = district.buses.find_or_create_by!(identifier: identifier)
      bus.bus_locations.create!(attributes)
    end
  end
end
