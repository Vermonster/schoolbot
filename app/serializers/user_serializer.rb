class UserSerializer < ActiveModel::Serializer
  attributes :id,
    :email,
    :unconfirmed_email,
    :name,
    :street,
    :city,
    :state,
    :zip_code,
    :latitude,
    :longitude,
    :locale,
    :intercom_hash

  def intercom_hash
    if INTERCOM_ENABLED
      OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha256'),
        ENV.fetch('INTERCOM_SECRET'),
        object.id.to_s
      )
    end
  end
end
