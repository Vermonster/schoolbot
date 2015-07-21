require 'rails_helper'

describe District do
  describe '#after_initialize' do
    it 'generates a random API secret' do
      district = District.new

      expect(district.api_secret).to be_present
    end

    it 'does not overwrite an existing API secret' do
      api_secret = create(:district).api_secret
      district = District.first # re-initialize

      expect(district.api_secret).to eq api_secret
    end
  end

  describe "#update_bus_locations!" do
    include ZonarStub
    before { stub_zonar }

    let(:district) { create :district }

    it "creates one location record for each row in csv" do
      district.update_bus_locations!
      expect(BusLocation.count).to eq zonar_csv_rows.count
    end

    it "creates one bus for each unique asset in csv" do
      district.update_bus_locations!
      expect(Bus.count).to eq zonar_csv_rows.map { |r| r["Asset No."] }.uniq.count
    end

    it "creates one bus for non-existing bus" do
      district.update_bus_locations!
      matching_buses = Bus.where(identifier: 'MB033 - 051073')
      expect(matching_buses.count).to eq 1
    end

    it "creates location after bus already exists" do
      somebus = create :bus, district: district, identifier: 'MB033 - 051073'
      district.update_bus_locations!
      bus_location = BusLocation.find_by_bus_id(somebus.id)
      expect(bus_location).to be_present
    end

    it "location has recorded_at datetime" do
      district.update_bus_locations!
      location = Bus.find_by_identifier('022051').bus_locations.order(:recorded_at).last
      expect(location.recorded_at.to_s).to eq '2015-07-24 12:27:12 UTC'
    end
  end
end
