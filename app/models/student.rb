class Student < ActiveRecord::Base
  belongs_to :district
  has_many :bus_assignments
  has_many :student_labels

  validates! :digest, length: { is: 64 }, format: { with: /\A[0-9a-f]*\z/ }

  before_validation -> { digest.try(:downcase!) }

  def current_bus_assignment
    bus_assignments.order(created_at: :desc).first
  end
end
