class Student < ActiveRecord::Base
  has_many :student_labels
  has_many :users, through: :student_labels

  validates :sha, presence: true
end
