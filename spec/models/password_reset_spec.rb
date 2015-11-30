require 'rails_helper'

describe PasswordReset do
  describe '.init' do
    it 'initializes a password reset by user email' do
      user = create(:user, email: 'jim@example.com')

      reset = PasswordReset.init('jim@example.com', district: user.district)

      expect(reset.user).to eq user
    end

    it 'only considers users in the given district' do
      create(:user, email: 'jim@example.com')
      other_district = create(:district)

      reset = PasswordReset.init('jim@example.com', district: other_district)

      expect(reset.user).to be nil
    end
  end

  describe '.find' do
    it 'initializes a password reset by token' do
      user = create(:user, reset_password_token: '12345')

      reset = PasswordReset.find('12345', district: user.district)

      expect(reset.user).to eq user
    end

    it 'only considers users in the given district' do
      create(:user, reset_password_token: '12345')
      other_district = create(:district)

      expect {
        PasswordReset.find('12345', district: other_district)
      }.to raise_error ActiveRecord::RecordNotFound
    end

    it 'only considers password-resettable users' do
      user = create(:user,
        reset_password_token: '12345',
        reset_password_sent_at: 8.days.ago
      )

      expect {
        PasswordReset.find('12345', district: user.district)
      }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe '#enable' do
    it 'returns false when the password reset is invalid' do
      user = build(:user)
      reset = PasswordReset.new(user)
      allow(reset).to receive(:valid?).and_return(false)

      expect(reset.enable).to be false
      expect(user).to_not be_persisted
    end

    it 'reset-enables the associated user and sends a confirmation email' do
      user = double
      reset_email = double
      reset = PasswordReset.new(user)
      allow(reset).to receive(:valid?).and_return(true)
      allow(user).to receive(:enable_password_reset!).and_return('enabled!')
      allow(PasswordResetMailer)
        .to receive(:password_reset).and_return(reset_email)
      allow(reset_email).to receive(:deliver_later).and_return(true)

      expect(reset.enable).to be true
      expect(user).to have_received(:enable_password_reset!)
      expect(reset_email).to have_received(:deliver_later)
    end
  end

  describe '#confirm' do
    it 'returns false when the password reset is invalid for confirmation' do
      user = build(:user)
      reset = PasswordReset.new(user)
      allow(reset).to receive(:valid?).with(:confirm).and_return(false)

      result = reset.confirm(
        password: 'testpass',
        password_confirmation: 'testpass'
      )

      expect(result).to be false
      expect(user).to_not be_persisted
    end

    it 'sets a new password for the associated user and saves it' do
      user = build(:user)
      reset = PasswordReset.new(user)
      allow(user).to receive(:disable_password_reset).and_return('disabled!')

      result = reset.confirm(
        password: 'testpass',
        password_confirmation: 'testpass'
      )

      expect(result).to be true
      expect(user).to be_persisted
      expect(user).to have_received(:disable_password_reset)
      expect(user.authenticate('testpass')).to be_truthy
    end
  end

  describe '#errors' do
    it 'collects errors from the associated user' do
      allow_any_instance_of(User).to receive(:errors).and_return(foo: 'bar')

      reset = PasswordReset.new(build(:user))

      expect(reset.errors[:foo]).to eq ['bar']
    end
  end

  describe '#valid?' do
    it 'returns true if the associated user is valid' do
      allow_any_instance_of(User).to receive(:valid?).and_return(true)

      reset = PasswordReset.new(build(:user))

      expect(reset).to be_valid
    end

    it 'returns false if the associated user is invalid' do
      allow_any_instance_of(User).to receive(:valid?).and_return(false)

      reset = PasswordReset.new(build(:user))

      expect(reset).to_not be_valid
    end
  end
end
