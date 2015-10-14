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

  before_validation -> { email.downcase! }
  before_save :ensure_authentication_token

  def address
    [street, city, state, zip_code].join(', ')
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

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      token = SecureRandom.hex
      break token unless User.find_by(authentication_token: token)
    end
  end
end
