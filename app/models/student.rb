class Student < ActiveRecord::Base
  belongs_to :district
  has_many :student_labels

  validates! :digest, presence: true
end
