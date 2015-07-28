class StudentLabel < ActiveRecord::Base
  belongs_to :school
  belongs_to :student
  belongs_to :user

  validates :nickname, presence: true
end
