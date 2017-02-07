require 'rails_helper'

describe SimulateBusLocationJob do
  def perform(iteration)
    described_class.perform_now(iteration)
  end

  it 'creates a location in a different position' do
    bus = create(:bus, identifier: '212')
    create(:bus_location, bus: bus) # create starting location

    # simulate bus to drive 5 degrees of rotation around a 1 mile radius
    perform(5)
    expect(BusLocation.first.latitude).not_to eq(BusLocation.second.latitude)
    expect(BusLocation.first.longitude).not_to eq(BusLocation.second.longitude)
    expect(BusLocation.count).to be 2
  end
end
