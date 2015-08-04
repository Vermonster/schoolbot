require 'rails_helper'

describe UpdateBusLocationsJob do
  include ZonarStubbing
  before { stub_zonar }

  it 'creates a location record for each row in the CSV data' do
    subject.perform(create(:district), since: Time.zone.now)

    expect(BusLocation.count).to eq zonar_csv_rows.count
  end

  it 'creates a bus for each unique asset in the CSV data' do
    subject.perform(create(:district), since: Time.zone.now)

    expect(Bus.count).to eq zonar_csv_rows.map { |r| r['Asset No.'] }.uniq.count
    expect(Bus.exists?(identifier: 'MB033 - 051073')).to be true
  end

  it 'creates a location record for a bus that already exists' do
    bus = create(:bus, identifier: 'MB033 - 051073')

    subject.perform(bus.district, since: Time.zone.now)

    expect(BusLocation.exists?(bus_id: bus.id)).to be true
  end

  it 'creates a location record with the correct timestamp' do
    subject.perform(create(:district), since: Time.zone.now)

    bus = Bus.find_by!(identifier: '022051')
    location = bus.bus_locations.order(:recorded_at).last
    expect(location.recorded_at.to_s).to eq '2015-07-24 12:27:12 UTC'
  end
end
