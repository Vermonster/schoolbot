class Confirmation
  include ActiveModel::Model
  include ActiveModel::SerializerSupport
  include ActiveModel::ForbiddenAttributesProtection

  attr_reader :user, :is_reconfirmation

  validates :user, presence: true

  def initialize(district:, token:)
    @user = district.users.find_by(confirmation_token: token)
    @is_reconfirmation = @user.try(:confirmed?)
  end

  def save
    if valid?
      if @is_reconfirmation
        user.reconfirm!
      else
        user.confirm!
      end
    else
      false
    end
  end
end
