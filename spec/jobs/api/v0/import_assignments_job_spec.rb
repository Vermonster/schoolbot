require 'rails_helper'

describe API::V0::ImportAssignmentsJob do
  def perform(district, assignments)
    described_class.perform_later(
      district: district,
      data: { assignments: assignments }.to_json
    )
  end

  it 'creates student and bus records for the specified district' do
    district = create(:district)

    perform(district, [
      { sha: '1' * 64, bus_identifier: 'ABC' },
      { sha: '2' * 64, bus_identifier: 'DEF' },
      { sha: '3' * 64, bus_identifier: 'ABC' }
    ])

    expect(Bus.count).to be 2
    expect(Student.count).to be 3
    expect(BusAssignment.count).to be 3
    expect(district.buses.count).to be 2
    expect(district.students.count).to be 3
  end

  it 'updates existing students with new bus assignments' do
    district = create(:district)
    student = create(:student,
      district: district,
      digest: '1' * 64,
      current_bus: create(:bus, district: district, identifier: 'ABC')
    )

    perform(district, [{ sha: '1' * 64, bus_identifier: 'DEF' }])

    expect(Bus.count).to be 2
    expect(Student.count).to be 1
    expect(BusAssignment.count).to be 2
    expect(district.buses.count).to be 2
    expect(district.students.count).to be 1
    expect(student.bus_assignments.count).to be 2
    expect(student.current_bus_assignment.bus.identifier).to eq 'DEF'
  end

  it 'unassigns students with blank or null bus identifiers' do
    district = create(:district)
    student = create(:student,
      district: district,
      digest: '1' * 64,
      current_bus: create(:bus, district: district, identifier: 'ABC')
    )

    perform(district, [
      { sha: '1' * 64, bus_identifier: '' },
      { sha: '2' * 64, bus_identifier: nil }
    ])

    expect(Bus.count).to be 1
    expect(Student.count).to be 2
    expect(BusAssignment.count).to be 3
    expect(district.buses.count).to be 1
    expect(district.students.count).to be 2
    expect(student.bus_assignments.count).to be 2
    expect(student.current_bus_assignment.bus).to be nil
  end

  it 'unassigns students whose digests are not in the input' do
    district = create(:district)
    assigned_student = create(:student,
      district: district,
      digest: '1' * 64,
      current_bus: create(:bus, district: district, identifier: 'ABC')
    )
    unassigned_student = create(:student,
      district: district,
      digest: '2' * 64,
      current_bus: create(:bus, district: district, identifier: 'DEF')
    )

    perform(district, [{ sha: '1' * 64, bus_identifier: 'ABC' }])

    expect(Bus.count).to be 2
    expect(Student.count).to be 2
    expect(district.buses.count).to be 2
    expect(district.students.count).to be 2
    expect(assigned_student.bus_assignments.count).to be 1
    expect(unassigned_student.bus_assignments.count).to be 2
    expect(unassigned_student.current_bus_assignment.bus).to be nil
  end

  it 'ignores input records that have no student digest' do
    district = create(:district)
    create(:student,
      district: district,
      digest: '1' * 64,
      current_bus: create(:bus, district: district, identifier: 'ABC')
    )

    perform(district, [
      { sha: '', bus_identifier: 'ABC' },
      { sha: nil, bus_identifier: 'ABC' },
      { sha: '1' * 64, bus_identifier: 'ABC' }
    ])

    expect(Student.count).to be 1
    expect(BusAssignment.count).to be 1
    expect(district.students.count).to be 1
  end

  it 'does not unassign students if the input is empty' do
    student = create(:student, digest: '1' * 64, current_bus: create(:bus))

    perform(student.district, [])

    expect(student.bus_assignments.count).to be 1
    expect(student.current_bus_assignment.bus).to_not be nil
  end

  it 'allows duplicate student records with last-record-wins semantics' do
    district = create(:district)
    create(:student,
      district: district,
      digest: '1' * 64,
      current_bus: create(:bus, district: district, identifier: 'ABC')
    )

    perform(district, [
      { sha: '1' * 64, bus_identifier: 'DEF' },
      { sha: '1' * 64, bus_identifier: 'XYZ' }
    ])

    expect(Bus.count).to be 3
    expect(Student.count).to be 1
    expect(BusAssignment.count).to be 3
    expect(district.buses.count).to be 3
    expect(district.students.count).to be 1
    expect(
      Student.find_by!(digest: '1' * 64).current_bus_assignment.bus.identifier
    ).to eq 'XYZ'
  end
end
