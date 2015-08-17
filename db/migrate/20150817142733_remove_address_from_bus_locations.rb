class RemoveAddressFromBusLocations < ActiveRecord::Migration
  def change
    remove_column :bus_locations, :address, :string
  end
end
