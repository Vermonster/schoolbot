class Bus < ActiveRecord::Base
  belongs_to :district
  has_many :bus_assignments
  has_many :bus_locations

  validates! :identifier, presence: true

  def recent_locations
    bus_locations.order(recorded_at: :desc).limit(5)
  end
end
