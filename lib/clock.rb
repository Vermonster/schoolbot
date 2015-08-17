require File.expand_path('../../config/boot', __FILE__)
require File.expand_path('../../config/environment', __FILE__)

module Clockwork
  every(20.seconds, 'UpdateBusLocations') do
    District.find_each do |district|
      UpdateBusLocationsJob.perform_later(district)
    end
  end
end
