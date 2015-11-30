class PasswordResetSerializer < ActiveModel::Serializer
  attributes :id, :email

  def id
    object.user.reset_password_token
  end

  def email
    object.user.email
  end
end
