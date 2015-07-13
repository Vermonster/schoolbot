require 'rails_helper'

describe User do
  describe '.find_for_authentication' do
    it 'delegates to find_first_by_auth_conditions with the found district' do
      district = create(:district, slug: 'foo')
      allow(User)
        .to receive(:find_first_by_auth_conditions)
        .with({ email: 'test' }, district_id: district.id)
        .and_return('found!')

      result = User.find_for_authentication(email: 'test', subdomain: 'foo')

      expect(result).to eq 'found!'
    end
  end
end
