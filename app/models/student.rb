class Student < ActiveRecord::Base
  belongs_to :district
  has_many :bus_assignments
  has_many :student_labels
  has_one :current_bus_assignment,
    -> { order(created_at: :desc) },
    class_name: BusAssignment

  validates! :digest, length: { is: 64 }, format: { with: /\A[0-9a-f]*\z/ }

  before_validation -> { digest.try(:downcase!) }
end
