class User < ActiveRecord::Base
  include Geocoded
  has_secure_password validate: false

  belongs_to :district
  has_many :student_labels
  has_many :students, through: :student_labels

  validates! :locale, presence: true
  validates :email, :name, :street, :city, :state, :zip_code, presence: true
  validates :email, uniqueness: true, format: { with: /\A.+@.+\..+\z/ }
  validates :password, length: { minimum: 8 }, allow_blank: true
  validate :address_must_geocode

  auto_strip_attributes :email, delete_whitespaces: true
  auto_strip_attributes :name, :street, :city, :state, :zip_code, squish: true

  before_validation -> { email.try(:downcase!) }
  before_save :ensure_tokens
  after_commit :update_intercom

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

  def reconfirm!
    self.email = unconfirmed_email
    self.unconfirmed_email = nil
    self.confirmation_token = nil
    save!
  end

  def disable_password_reset
    self.reset_password_token = nil
  end

  def enable_password_reset!
    self.reset_password_token = nil
    self.reset_password_sent_at = Time.current
    ensure_token(:reset_password_token)
    save!
  end

  def self.password_resettable
    where('reset_password_sent_at >= ?', 7.days.ago)
  end

  private

  def address_must_geocode
    if [street, city, state, zip_code].all?(&:present?) && latitude.blank?
      errors.add(:address, 'invalid')
    end
  end

  def ensure_tokens
    ensure_token(:authentication_token)
    ensure_token(:confirmation_token) if needs_confirmation_token?
  end

  def ensure_token(token_name)
    if self[token_name].blank?
      self[token_name] = loop do
        token = SecureRandom.hex
        break token unless User.exists?(token_name => token)
      end
    end
  end

  def needs_confirmation_token?
    !confirmed? || unconfirmed_email.present?
  end

  def update_intercom
    IntercomUpdateJob.perform_later(self) if INTERCOM_ENABLED
  end
end
