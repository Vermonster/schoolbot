class CreateBusLocations < ActiveRecord::Migration
  def change
    create_table :bus_locations do |t|
      t.references :bus, null: false, index: true, foreign_key: { on_delete: :restrict }
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.string :heading, null: false
      t.datetime :recorded_at, null: false
      t.float :distance
      t.float :speed
      t.float :acceleration
      t.string :reason
      t.string :zone
      t.string :address
      t.timestamps null: false
    end
  end
end
