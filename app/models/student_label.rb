class StudentLabel < ActiveRecord::Base
  belongs_to :school
  belongs_to :student
  belongs_to :user

  delegate :digest, to: :student, allow_nil: true

  validates :digest, :school, presence: true
  validates :nickname,
    presence: true,
    uniqueness: { scope: :user_id, case_sensitive: false }
  validate :student_must_be_unique_to_user

  auto_strip_attributes :nickname, squish: true

  def digest=(value)
    self.student = Student.find_by(digest: value)
  end

  private

  def student_must_be_unique_to_user
    errors.add(:digest, 'taken') if StudentLabel.exists?(student_id: student_id)
  end
end
