class DistrictSerializer < ActiveModel::Serializer
  has_many :schools
  attributes :id, :name, :contact_phone, :contact_email
end
