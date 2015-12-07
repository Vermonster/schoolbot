require 'rails_helper'

describe BusLocation do
  describe '.recent' do
    it 'returns the 8 most recently recorded locations' do
      bus = create(:bus)
      Timecop.freeze(Time.current.change(usec: 0)) do
        [
          5.seconds.ago,
          23.seconds.ago,
          12.seconds.ago,
          4.minutes.ago,
          57.seconds.ago,
          2.minutes.ago,
          1.minute.ago,
          44.seconds.ago,
          3.minutes.ago
        ].each do |time|
          create(:bus_location, bus: bus, recorded_at: time)
        end

        expect(BusLocation.recent.map(&:recorded_at)).to eq [
          5.seconds.ago,
          12.seconds.ago,
          23.seconds.ago,
          44.seconds.ago,
          57.seconds.ago,
          1.minute.ago,
          2.minutes.ago,
          3.minutes.ago
        ]
      end
    end

    it 'returns only locations recorded within the last 5 minutes' do
      bus = create(:bus)
      Timecop.freeze(Time.current.change(usec: 0)) do
        [
          40.seconds.ago,
          90.seconds.ago,
          2.minutes.ago,
          4.minutes.ago,
          299.seconds.ago,
          5.minutes.ago,
          6.minutes.ago
        ].each do |time|
          create(:bus_location, bus: bus, recorded_at: time)
        end

        expect(BusLocation.recent.map(&:recorded_at)).to eq [
          40.seconds.ago,
          90.seconds.ago,
          2.minutes.ago,
          4.minutes.ago,
          299.seconds.ago
        ]
      end
    end
  end
end
