require File.expand_path('../../config/boot', __FILE__)
require File.expand_path('../../config/environment', __FILE__)

module Clockwork
  error_handler do |error|
    Airbrake.notify(error)
  end

  every(Zonar::REQUEST_INTERVAL, 'UpdateBusLocations') do
    District.active.find_each do |district|
      UpdateBusLocationsJob.perform_later(district)
    end
  end

  every(1.day, 'CleanBusLocations') do
    BusLocation.where('created_at < ?', 1.week.ago).delete_all
  end

  if INTERCOM_ENABLED
    every(1.day, 'IntercomUpdateDistrict') do
      District.find_each do |district|
        IntercomUpdateJob.perform_later(district)
      end
    end
  end
end
