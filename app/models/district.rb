class District < ActiveRecord::Base
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

  private

  def assign_api_secret
    self.api_secret = SecureRandom.hex
  end
end
