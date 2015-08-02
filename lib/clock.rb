require File.expand_path('../../config/boot', __FILE__)
require File.expand_path('../../config/environment', __FILE__)

include Clockwork

every(30.seconds, 'Districts update bus locations') do
  District.all.each { |district| district.delay.update_bus_locations! }
end
