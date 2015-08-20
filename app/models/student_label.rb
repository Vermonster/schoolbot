class StudentLabel < ActiveRecord::Base
  belongs_to :school
  belongs_to :student
  belongs_to :user

  delegate :digest, to: :student, allow_nil: true

  validates :nickname, presence: true, uniqueness: { scope: :user_id }
  validates :digest, :school, presence: true
end
