class District < ActiveRecord::Base
  has_many :buses
  has_many :schools
  has_many :students
  has_many :users

  after_initialize :assign_api_secret, if: :new_record?

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

  def zonar
    @zonar ||= Zonar.new self
  end

  def update_bus_locations!
    zonar.bus_events_since(30.seconds.ago).each do |attrs|
      bus = buses.find_or_create_by!(identifier: attrs.delete(:bus_identifier))
      bus.bus_locations.create!(attrs)
    end
  end

  private

  def assign_api_secret
    self.api_secret = SecureRandom.hex
  end
end
