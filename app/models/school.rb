class School < ActiveRecord::Base
  belongs_to :district

  geocoded_by :address
  after_validation :geocode, unless: :skip_geocode?

  validates :name, :address, presence: true

  private

  def skip_geocode?
    new_record? && latitude.present? && longitude.present?
  end
end
