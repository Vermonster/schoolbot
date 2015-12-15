require 'rails_helper'

describe StudentLabel do
  describe 'validation' do
    it 'disallows duplicate nicknames per user, ignoring case and whitespace' do
      user = create(:user)
      create(:student_label, user: user, nickname: ' Jack  sprat')
      student_label = build(:student_label, user: user, nickname: 'jack Sprat ')

      expect(student_label).to_not be_valid
    end

    it 'enforces uniqueness of the student per-user as a "digest" validation' do
      user = create(:user)
      student = create(:student)
      create(:student_label, student: student, user: user)

      student_label = build(:student_label, student: student, user: user)

      expect(student_label).to_not be_valid
      expect(student_label.errors[:digest]).to eq ['taken']
    end

    it 'allows the same student to be associated with multiple users' do
      student = create(:student)
      create(:student_label, student: student)

      student_label = build(:student_label, student: student)

      expect(student_label).to be_valid
    end
  end
end
