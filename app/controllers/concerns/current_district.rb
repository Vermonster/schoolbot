module CurrentDistrict
  extend ActiveSupport::Concern

  private

  def current_district
    @_current_district ||=
      check_by_authorization_header ||
      District.active.find_by!(slug: request.subdomains.first)
  end

  def check_by_authorization_header
    unless request.authorization.nil?
      User.where(email: authorization_header_email)
          .where.not(confirmed_at: nil).first&.district
    end
  end

  def authorization_header_email
    request.authorization.match(/email="([^"]*)"/)[1]
  end
end
