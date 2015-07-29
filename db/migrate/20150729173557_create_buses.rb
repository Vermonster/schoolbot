class CreateBuses < ActiveRecord::Migration
  def change
    create_table :buses do |t|
      t.references :district, null: false, index: true, foreign_key: { on_delete: :restrict }
      t.text :identifier, null: false
      t.timestamps null: false
    end

    add_index :buses, [:district_id, :identifier], unique: true
  end
end
