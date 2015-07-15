class School < ActiveRecord::Base
  belongs_to :district

  geocoded_by :address
  after_validation :geocode

  validates :name, :address, presence: true
end
