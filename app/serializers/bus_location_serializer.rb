class BusLocationSerializer < ActiveModel::Serializer
  attributes :id, :bus_id, :latitude, :longitude, :heading, :recorded_at
end
