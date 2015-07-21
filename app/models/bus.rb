class Bus < ActiveRecord::Base
  belongs_to :district
  has_many :bus_assignments
  has_many :bus_locations

  validates! :identifier, presence: true
end
