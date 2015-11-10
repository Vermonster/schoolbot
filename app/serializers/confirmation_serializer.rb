class ConfirmationSerializer < ActiveModel::Serializer
  attributes :user_email, :user_token

  def user_email
    object.user.email
  end

  def user_token
    object.user.authentication_token
  end
end
