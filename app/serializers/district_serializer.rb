class DistrictSerializer < ActiveModel::Serializer
  has_many :schools
  attributes :id, :name, :contact_phone, :contact_email, :logo_url, :created_at

  def logo_url
    object.logo.url
  end
end
