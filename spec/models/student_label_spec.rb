require 'rails_helper'

describe StudentLabel do
  describe 'validation' do
    it 'disallows duplicate nicknames per user, ignoring case and whitespace' do
      user = create(:user)
      create(:student_label, user: user, nickname: ' Jack  sprat')
      student_label = build(:student_label, user: user, nickname: 'jack Sprat ')

      expect(student_label).to_not be_valid
    end
  end
end
