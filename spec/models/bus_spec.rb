require 'rails_helper'

describe Bus do
  describe '#recent_locations' do
    it 'returns the 5 most recently recorded locations of the bus' do
      bus = create(:bus)
      Timecop.freeze do
        [
          5.minutes.ago,
          23.minutes.ago,
          12.minutes.ago,
          4.hours.ago,
          57.minutes.ago,
          2.hours.ago
        ].each do |time|
          create(:bus_location, bus: bus, recorded_at: time)
        end

        expect(bus.recent_locations.map(&:recorded_at)).to eq [
          5.minutes.ago,
          12.minutes.ago,
          23.minutes.ago,
          57.minutes.ago,
          2.hours.ago
        ]
      end
    end
  end
end
