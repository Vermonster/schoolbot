class BusLocation < ActiveRecord::Base
  belongs_to :bus

  def self.recent
    where('recorded_at > ?', 5.minutes.ago).order(recorded_at: :desc).limit(8)
  end

  # returns distance between user and bus_location
  def near_user(user)
    Geocoder::Calculations.distance_between([latitude, longitude], [user.latitude, user.longitude])
  end
end
