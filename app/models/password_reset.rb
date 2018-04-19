class PasswordReset
  include ActiveModel::Model
  include ActiveModel::SerializerSupport
  include ActiveModel::ForbiddenAttributesProtection

  attr_reader :user
  delegate :password,
    :password=,
    :password_confirmation,
    :password_confirmation=,
    to: :user

  validates :user, presence: true
  validates :password, presence: true, on: :confirm

  ATTRIBUTES = %w[password password_confirmation]

  def self.init(email, district:)
    new(district.users.find_by(email: email))
  end

  def self.find(token, district:)
    new(
      district.users.password_resettable.find_by!(reset_password_token: token)
    )
  end

  def initialize(user)
    @user = user
  end

  def enable
    if valid?
      user.enable_password_reset!
      PasswordResetMailer.password_reset(user).deliver_later
      true
    else
      false
    end
  end

  def confirm(attributes)
    attributes.each do |name, value|
      public_send("#{name}=", value)
    end

    if valid?(:confirm)
      user.disable_password_reset
      user.save!
      true
    else
      false
    end
  end

  def errors
    errors = super

    if user.present?
      user.errors.each do |attribute, error|
        errors.add(attribute, error) unless errors.added?(attribute, error)
      end
    end

    errors
  end

  def valid?(context = nil)
    super && user.present? && user.valid?(context)
  end
end
