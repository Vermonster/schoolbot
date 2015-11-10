require 'rails_helper'

describe Confirmation do
  describe '#save' do
    it 'confirms the user matching the provided token' do
      district = create(:district)
      user = create(:user, :unconfirmed,
        district: district,
        confirmation_token: '123'
      )

      confirmation = Confirmation.new(district: district, token: '123')
      confirmation.save

      expect(confirmation).to be_valid
      expect(user.reload).to be_confirmed
    end

    it 'does not confirm if the wrong district is given' do
      district = create(:district)
      user = create(:user, :unconfirmed, confirmation_token: '999')

      confirmation = Confirmation.new(district: district, token: '999')
      confirmation.save

      expect(confirmation).to_not be_valid
      expect(user.reload).to_not be_confirmed
    end

    it 'does not confirm if the wrong confirmation token is given' do
      district = create(:district)
      user = create(:user, :unconfirmed,
        district: district,
        confirmation_token: '123'
      )

      confirmation = Confirmation.new(district: district, token: '999')
      confirmation.save

      expect(confirmation).to_not be_valid
      expect(user.reload).to_not be_confirmed
    end
  end
end
