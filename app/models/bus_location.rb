class BusLocation < ActiveRecord::Base
  belongs_to :bus

  def self.recent
    where('recorded_at > ?', 5.minutes.ago).order(recorded_at: :desc).limit(8)
  end
end
