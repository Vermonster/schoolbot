require 'rails_helper'

describe User do
  describe 'validation' do
    it 'downcases and removes all whitespace from the email address' do
      user = build(:user, email: ' Test @Example.com  ')

      user.validate!

      expect(user.email).to eq 'test@example.com'
    end
  end
end
