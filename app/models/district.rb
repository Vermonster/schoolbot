class District < ActiveRecord::Base
  has_many :buses
  has_many :bus_locations, through: :buses
  has_many :schools
  has_many :students
  has_many :users

  has_attached_file :logo
  validates_attachment :logo,
    presence: true,
    file_name: { matches: /svg\Z/ },
    content_type: { content_type: 'image/svg+xml' }

  after_initialize :assign_api_secret, if: :new_record?
  before_validation -> { contact_email&.downcase! }

  validates :name,
    :slug,
    :contact_phone,
    :contact_email,
    :api_secret,
    :zonar_customer,
    :zonar_username,
    :zonar_password,
    presence: true

  validates :slug,
    length: { minimum: 1, maximum: 63 },
    format: { with: /\A[0-9a-z-]*\z/ }

  auto_strip_attributes :name, :contact_phone, squish: true
  auto_strip_attributes :contact_email, delete_whitespaces: true

  def self.active
    where(is_active: true)
  end

  private

  def assign_api_secret
    self.api_secret = SecureRandom.hex
  end
end
