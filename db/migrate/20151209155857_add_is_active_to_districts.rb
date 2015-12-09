class AddIsActiveToDistricts < ActiveRecord::Migration
  def change
    add_column :districts, :is_active, :boolean, null: false, default: true
  end
end
