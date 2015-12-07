class Bus < ActiveRecord::Base
  belongs_to :district
  has_many :bus_assignments
  has_many :bus_locations
  has_many :recent_locations, -> { recent }, class_name: BusLocation

  validates! :identifier, presence: true
end
