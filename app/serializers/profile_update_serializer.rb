class ProfileUpdateSerializer < ActiveModel::Serializer
  self.root = 'user'

  attributes :id, :email, :unconfirmed_email
end
