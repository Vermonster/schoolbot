module DistrictAuthenticated
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_district!
  end

  private

  def authenticate_district!
    head :unauthorized if authenticated_district.blank?
  end

  def authenticated_district
    @_authenticated_district ||= authenticate_with_http_basic do |user, pass|
      District.active.find_by(slug: user, api_secret: pass)
    end
  end
end
