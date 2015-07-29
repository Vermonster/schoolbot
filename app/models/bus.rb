class Bus < ActiveRecord::Base
  belongs_to :district
  has_many :bus_assignments

  validates! :identifier, presence: true
end
