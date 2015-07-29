require 'rails_helper'

describe API::V0::ImportAssignmentsJob do
  it 'creates student and bus records for the specified district' do
    district = create(:district)
    assignments = [
      { sha: '123', bus_identifier: 'ABC' },
      { sha: '456', bus_identifier: 'DEF' },
      { sha: '789', bus_identifier: 'ABC' }
    ]

    subject.perform(district: district, assignments: assignments)

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
      digest: '123',
      current_bus: create(:bus, district: district, identifier: 'ABC')
    )
    assignments = [
      { sha: '123', bus_identifier: 'DEF' }
    ]

    subject.perform(district: district, assignments: assignments)

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
      digest: '123',
      current_bus: create(:bus, district: district, identifier: 'ABC')
    )
    assignments = [
      { sha: '123', bus_identifier: '' },
      { sha: '456', bus_identifier: nil }
    ]

    subject.perform(district: district, assignments: assignments)

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
      digest: '123',
      current_bus: create(:bus, district: district, identifier: 'ABC')
    )
    unassigned_student = create(:student,
      district: district,
      digest: '456',
      current_bus: create(:bus, district: district, identifier: 'DEF')
    )
    assignments = [
      { sha: '123', bus_identifier: 'ABC' }
    ]

    subject.perform(district: district, assignments: assignments)

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
      digest: '123',
      current_bus: create(:bus, district: district, identifier: 'ABC')
    )
    assignments = [
      { sha: '', bus_identifier: 'ABC' },
      { sha: nil, bus_identifier: 'ABC' },
      { sha: '123', bus_identifier: 'ABC' }
    ]

    subject.perform(district: district, assignments: assignments)

    expect(Student.count).to be 1
    expect(BusAssignment.count).to be 1
    expect(district.students.count).to be 1
  end

  it 'does not unassign students if the input is empty' do
    student = create(:student, digest: '123', current_bus: create(:bus))

    subject.perform(district: student.district, assignments: [])

    expect(student.bus_assignments.count).to be 1
    expect(student.current_bus_assignment.bus).to_not be nil
  end

  it 'allows duplicate student records with last-record-wins semantics' do
    district = create(:district)
    create(:student,
      district: district,
      digest: '123',
      current_bus: create(:bus, district: district, identifier: 'ABC')
    )
    assignments = [
      { sha: '123', bus_identifier: 'DEF' },
      { sha: '123', bus_identifier: 'XYZ' }
    ]

    subject.perform(district: district, assignments: assignments)

    expect(Bus.count).to be 3
    expect(Student.count).to be 1
    expect(BusAssignment.count).to be 3
    expect(district.buses.count).to be 3
    expect(district.students.count).to be 1
    expect(
      Student.find_by!(digest: '123').current_bus_assignment.bus.identifier
    ).to eq 'XYZ'
  end
end
