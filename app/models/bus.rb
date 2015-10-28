class Bus < ActiveRecord::Base
  belongs_to :district
  has_many :bus_assignments
  has_many :bus_locations

  validates! :identifier, presence: true

  def recent_locations
    bus_locations
      .where('recorded_at > ?', 5.minutes.ago)
      .order(recorded_at: :desc)
      .limit(8)
  end
end
