require File.expand_path('../../config/boot', __FILE__)
require File.expand_path('../../config/environment', __FILE__)

module Clockwork
  error_handler do |error|
    Airbrake.notify(error)
  end

  unless ENV['ENABLE_BUS_LOCATION_SIMULATOR'].present?
    every(Zonar::REQUEST_INTERVAL, 'UpdateBusLocations') do
      District.active.find_each do |district|
        UpdateBusLocationsJob.perform_later(district)
      end
    end
  end

  every(1.day, 'CleanBusLocations') do
    BusLocation.where('created_at < ?', 1.week.ago).delete_all
  end

  if ENV['ENABLE_BUS_LOCATION_SIMULATOR'].present?
    iteration = 0
    every(Zonar::REQUEST_INTERVAL, 'SimulateBusLocation') do
      SimulateBusLocationJob.perform_later(iteration)
      iteration = iteration >= 360 ? 0 : iteration += 1 # reset circle
    end
  end

  if INTERCOM_ENABLED
    every(1.day, 'IntercomUpdateDistrict') do
      District.find_each do |district|
        IntercomUpdateJob.perform_later('update_district', district)
      end
    end
  end
end
