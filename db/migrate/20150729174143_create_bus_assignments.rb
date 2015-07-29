class CreateBusAssignments < ActiveRecord::Migration
  def change
    create_table :bus_assignments do |t|
      t.references :bus, null: true, index: true, foreign_key: { on_delete: :restrict }
      t.references :student, null: false, index: true, foreign_key: { on_delete: :cascade }
      t.timestamps null: false
    end
  end
end
