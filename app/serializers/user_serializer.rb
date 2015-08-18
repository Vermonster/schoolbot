class UserSerializer < ActiveModel::Serializer
  attributes :id,
    :email,
    :name,
    :street,
    :city,
    :state,
    :zip_code
end
