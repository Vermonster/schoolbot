class User < ActiveRecord::Base
  include Geocoded
  has_secure_password validate: false

  belongs_to :district
  has_many :student_labels
  has_many :students, through: :student_labels

  validates :email, :name, :street, :city, :state, :zip_code, presence: true
  validates :email, uniqueness: true, format: { with: /.+@.+\..+/ }
  validates :password, length: { minimum: 8 }, allow_blank: true
  validate :address_must_geocode

  auto_strip_attributes :email, delete_whitespaces: true
  auto_strip_attributes :name, :street, :city, :state, :zip_code, squish: true

  before_validation -> { email.try(:downcase!) }
  before_save :ensure_tokens

  def address
    [street, city, state, zip_code].join(', ')
  end

  def confirm!
    self.confirmed_at = Time.current
    self.confirmation_token = nil
    save!
  end

  def confirmed?
    !confirmed_at.nil? && confirmed_at <= Time.current
  end

  def self.confirmed
    where('confirmed_at <= ?', Time.current)
  end

  # Don't unset the password digest if a blank password is sent
  def password=(value)
    super if value.present?
  end

  private

  def address_must_geocode
    if [street, city, state, zip_code].all?(&:present?) && latitude.blank?
      errors.add(:address, 'invalid')
    end
  end

  def ensure_tokens
    ensure_token(:authentication_token)
    ensure_token(:confirmation_token) unless confirmed?
  end

  def ensure_token(token_name)
    if self[token_name].blank?
      self[token_name] = loop do
        token = SecureRandom.hex
        break token unless User.exists?(token_name => token)
      end
    end
  end
end
