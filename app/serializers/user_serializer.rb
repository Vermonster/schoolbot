class UserSerializer < ActiveModel::Serializer
  attributes :id,
    :email,
    :first_name,
    :last_name,
    :street_address,
    :city,
    :zip_code
end
