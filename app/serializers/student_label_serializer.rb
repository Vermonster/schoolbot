class StudentLabelSerializer < ActiveModel::Serializer
  self.root = 'student'

  has_one :bus
  has_one :school
  attributes :id, :nickname

  def bus
    object.student.current_bus_assignment.try(:bus)
  end
end
