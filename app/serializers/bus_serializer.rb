class BusSerializer < ActiveModel::Serializer
  has_many :bus_locations
  attributes :id, :identifier

  def bus_locations
    object.recent_locations
  end
end
