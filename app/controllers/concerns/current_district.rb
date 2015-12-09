module CurrentDistrict
  extend ActiveSupport::Concern

  private

  def current_district
    @_current_district ||=
      District.active.find_by!(slug: request.subdomains.first)
  end
end
