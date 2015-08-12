class StudentSerializer < ActiveModel::Serializer
  has_one :bus
  has_one :school
  attributes :id, :nickname

  delegate :school, :nickname, to: :current_label

  def bus
    object.current_bus_assignment.try(:bus)
  end

  private

  def current_label
    object.student_labels.find_by(user_id: scope.id)
  end
end
