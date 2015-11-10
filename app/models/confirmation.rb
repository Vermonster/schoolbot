class Confirmation
  include ActiveModel::Model
  include ActiveModel::SerializerSupport
  include ActiveModel::ForbiddenAttributesProtection

  attr_reader :user

  validates :user, presence: true

  def initialize(district:, token:)
    @user = district.users.find_by(confirmation_token: token)
  end

  def save
    if valid?
      user.confirm!
    else
      false
    end
  end
end
