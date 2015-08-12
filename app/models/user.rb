class User < ActiveRecord::Base
  belongs_to :district
  has_many :student_labels
  has_many :students, through: :student_labels

  devise :database_authenticatable,
    :registerable,
    :recoverable,
    :rememberable,
    :trackable,
    :validatable,
    :lockable,
    request_keys: [:subdomains]

  before_save :ensure_authentication_token

  def self.find_for_authentication(conditions)
    district = District.find_by!(slug: conditions.delete(:subdomains).first)
    find_first_by_auth_conditions(conditions, district_id: district.id)
  end

  private

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.find_by(authentication_token: token)
    end
  end
end
