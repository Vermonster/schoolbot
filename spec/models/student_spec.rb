require 'rails_helper'

describe Student do
  describe 'validation' do
    it 'allows and normalizes uppercase or lowercase letters in digests' do
      student = create(:student, digest: 'aBcdEfeD' * 8)

      expect(student).to be_valid
      expect(student.digest).to eq 'abcdefed' * 8
    end

    it 'strictly disallows invalid digests' do
      ['0' * 63, '0' * 65, 'nope' * 16].each do |invalid_digest|
        expect{
          create(:student, digest: invalid_digest)
        }.to raise_error ActiveModel::StrictValidationFailed
      end
    end
  end
end
