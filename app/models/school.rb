class School < ActiveRecord::Base
  include Geocoded

  belongs_to :district

  validates! :name, :address, presence: true

  auto_strip_attributes :name, :address, squish: true
end
