class SchoolSerializer < ActiveModel::Serializer
  attributes :id, :name, :address, :latitude, :longitude
end
