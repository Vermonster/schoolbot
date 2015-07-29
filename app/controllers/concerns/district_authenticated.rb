module DistrictAuthenticated
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_district!
  end

  private

  def authenticate_district!
    head :unauthorized unless current_district.present?
  end

  def current_district
    @_current_district ||= authenticate_with_http_basic do |username, password|
      District.find_by(slug: username, api_secret: password)
    end
  end
end
