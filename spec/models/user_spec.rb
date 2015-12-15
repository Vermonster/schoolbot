require 'rails_helper'

describe User do
  describe 'before_save' do
    it 'ensures the user has authentication and confirmation tokens' do
      user = create(:user, :unconfirmed,
        authentication_token: nil,
        confirmation_token: nil
      )

      expect(user.authentication_token).to be_present
      expect(user.confirmation_token).to be_present
    end

    it 'does not overwrite provided authentication or confirmation tokens' do
      user = create(:user, authentication_token: '1', confirmation_token: '2')

      expect(user.authentication_token).to eq '1'
      expect(user.confirmation_token).to eq '2'
    end

    it 'does not generate a confirmation token if the user is confirmed' do
      user = create(:user, confirmation_token: nil)

      expect(user.confirmation_token).to be nil
    end
  end

  describe 'after_commit' do
    it 'enqueues an Intercom update when the user is updated or destroyed' do
      user = build(:user)
      actions = [
        -> { user.save! },
        -> { user.update!(name: 'test') },
        -> { user.destroy! }
      ]

      actions.each do |action|
        expect {
          action.call
        }.to have_enqueued_job(IntercomUpdateJob).with(user)
      end
    end
  end

  describe 'validation' do
    it 'downcases and removes all whitespace from the email address' do
      user = build(:user, email: ' Test @Example.com  ')

      user.validate!

      expect(user.email).to eq 'test@example.com'
    end
  end

  describe '#confirm!' do
    it 'confirms and saves the user' do
      user = build(:user, :unconfirmed)

      Timecop.freeze(Time.current.change(usec: 0)) do
        user.confirm!

        expect(user.confirmed_at).to eq Time.current
        expect(user.confirmation_token).to be nil
        expect(user).to be_persisted
      end
    end
  end

  describe '#confirmed?' do
    it 'is true if the user has a past confirmation date' do
      expect(build(:user, confirmed_at: 1.minute.ago)).to be_confirmed
      expect(build(:user, confirmed_at: Time.current)).to be_confirmed
      expect(build(:user, confirmed_at: nil)).to_not be_confirmed
      expect(build(:user, confirmed_at: 1.minute.from_now)).to_not be_confirmed
    end
  end

  describe '.confirmed' do
    it 'returns only users with a past confirmation date' do
      users = [
        create(:user, confirmed_at: 1.minute.ago),
        create(:user, confirmed_at: nil),
        create(:user, confirmed_at: Time.current),
        create(:user, confirmed_at: 1.minute.from_now)
      ]

      expect(User.confirmed).to match_array [users[0], users[2]]
    end
  end

  describe '#enable_password_reset!' do
    it 'randomizes the password reset token and sets the "sent at" date' do
      user = build(:user,
        reset_password_token: '123',
        reset_password_sent_at: 1.day.ago
      )

      Timecop.freeze(Time.current.change(usec: 0)) do
        user.enable_password_reset!

        expect(user.reset_password_token).to_not eq '123'
        expect(user.reset_password_sent_at).to eq Time.current
        expect(user).to be_persisted
      end
    end
  end

  describe '.password_resettable' do
    it 'returns users enabled for password resets within the last 7 days' do
      users = [
        create(:user, reset_password_sent_at: 8.days.ago),
        create(:user, reset_password_sent_at: 6.days.ago),
        create(:user, reset_password_sent_at: nil),
        create(:user, reset_password_sent_at: Time.current)
      ]

      expect(User.password_resettable).to match_array [users[1], users[3]]
    end
  end
end
