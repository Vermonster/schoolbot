class Student < ActiveRecord::Base
  belongs_to :district
  has_many :bus_assignments
  has_many :student_labels

  validates! :digest, presence: true

  def current_bus_assignment
    bus_assignments.order(created_at: :desc).first
  end
end
