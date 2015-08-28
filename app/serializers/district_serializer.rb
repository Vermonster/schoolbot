class DistrictSerializer < ActiveModel::Serializer
  has_many :schools
  attributes :id, :name, :contact_phone, :contact_email, :logo_url

  def logo_url
    object.logo.url
  end
end
