class AddIndexesToBusLocations < ActiveRecord::Migration
  def change
    add_index :bus_locations, :recorded_at
    add_index :bus_locations, [:bus_id, :recorded_at], unique: true
  end
end
