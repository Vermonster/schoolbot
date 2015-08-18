class School < ActiveRecord::Base
  include Geocoded

  belongs_to :district

  validates :name, :address, presence: true
end
