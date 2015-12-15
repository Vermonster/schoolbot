require 'rails_helper'

describe UpdateBusLocationsJob do
  include ZonarStubbing
  before { stub_zonar }

  def perform(district)
    described_class.perform_now(district)
  end

  it 'handles an empty Zonar response' do
    stub_zonar(zonar_csv_headers)

    perform(create(:district))

    expect(BusLocation.count).to be 0
  end

  it 'creates a location record for each row in the CSV data' do
    perform(create(:district))

    expect(BusLocation.count).to eq zonar_csv_rows.count
  end

  it 'creates a bus for each unique asset in the CSV data' do
    perform(create(:district))

    expect(Bus.count).to eq zonar_csv_rows.map { |r| r['Asset No.'] }.uniq.count
    expect(Bus.exists?(identifier: 'MB033 - 051073')).to be true
  end

  it 'creates a location record for a bus that already exists' do
    bus = create(:bus, identifier: 'MB033 - 051073')

    perform(bus.district)

    expect(BusLocation.exists?(bus_id: bus.id)).to be true
  end

  it 'creates a location record with the correct timestamp' do
    perform(create(:district))

    bus = Bus.find_by!(identifier: '022051')
    location = bus.bus_locations.order(:recorded_at).last
    expect(location.recorded_at.to_s).to eq '2015-07-24 12:27:12 UTC'
  end

  it 'does not create duplicate location records with the same timestamp' do
    time = Time.zone.parse('2015-07-24 12:27:12 UTC')
    bus = create(:bus, identifier: '022051')
    create(:bus_location, bus: bus, recorded_at: time)

    perform(bus.district)

    expect(bus.bus_locations.where(recorded_at: time).count).to be 1
  end
end
