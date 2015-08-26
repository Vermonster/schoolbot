module Geocoded
  extend ActiveSupport::Concern

  included do
    geocoded_by :address
    before_validation :geocode, unless: :skip_geocode?
  end

  private

  def skip_geocode?
    new_record? && latitude.present? && longitude.present?
  end
end
