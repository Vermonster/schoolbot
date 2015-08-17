class ChangeMoreStringColumnsToText < ActiveRecord::Migration
  def up
    change_column :bus_locations, :heading, :text, null: false
    change_column :bus_locations, :reason, :text
    change_column :bus_locations, :zone, :text
  end

  def down
    change_column :bus_locations, :heading, :string, null: false
    change_column :bus_locations, :reason, :string
    change_column :bus_locations, :zone, :string
  end
end
