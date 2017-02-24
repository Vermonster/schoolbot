require File.expand_path('../../config/boot', __FILE__)
require File.expand_path('../../config/environment', __FILE__)
require 'push_notification_service'

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

  every(25.seconds, 'CheckUserNotifications') do
    # User.find_each do |user|
    #   user.most_recent_bus_locations.each do |bus_location|
    #     if bus_location.near_user(user) <= 1.5
    #       rails "bus is close!"
    #       puts "yay its close!"
    #     end
    #   end
    # end
  end

  if INTERCOM_ENABLED
    every(1.day, 'IntercomUpdateDistrict') do
      District.find_each do |district|
        IntercomUpdateJob.perform_later('update_district', district)
      end
    end
  end
end
