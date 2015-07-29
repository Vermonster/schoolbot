require 'rails_helper'

describe API::V0::StudentSerializer do
  describe '#bus_identifier' do
    it "returns the identifier of the student's current bus" do
      assignment = create(:bus_assignment, bus: create(:bus, identifier: 'ABC'))

      serializer = described_class.new(assignment.student)

      expect(serializer.bus_identifier).to eq 'ABC'
    end

    it 'returns nil if the student has a null bus assignment' do
      assignment = build_stubbed(:bus_assignment, bus: nil)

      serializer = described_class.new(assignment.student)

      expect(serializer.bus_identifier).to be nil
    end

    it 'returns nil if the student has no bus assignments' do
      serializer = described_class.new(build_stubbed(:student))

      expect(serializer.bus_identifier).to be nil
    end
  end
end
