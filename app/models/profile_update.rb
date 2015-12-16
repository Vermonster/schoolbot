class ProfileUpdate
  include ActiveModel::Model
  include ActiveModel::SerializerSupport
  include ActiveModel::ForbiddenAttributesProtection

  ATTRIBUTES = Registration::USER_ATTRIBUTES + %i(unconfirmed_email)

  ATTRIBUTES.each do |attribute|
    delegate attribute, "#{attribute}=", to: :user
  end

  delegate :id, :valid?, :errors, to: :user

  def initialize(user:, attributes: {})
    self.user = user

    if attributes[:password].blank?
      attributes.delete(:password)
      attributes.delete(:password_confirmation)
    end

    super(attributes)
  end

  def save
    if valid?
      save_with_email_confirmation!
      true
    else
      false
    end
  end

  private

  attr_accessor :user

  def save_with_email_confirmation!
    if user.email_changed?
      user.unconfirmed_email = user.email
      user.restore_attributes([:email])
      user.save!
      ConfirmationMailer.reconfirmation(user).deliver_later
    else
      user.save!
    end
  end
end
