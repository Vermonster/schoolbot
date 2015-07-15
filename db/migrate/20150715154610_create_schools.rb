class CreateSchools < ActiveRecord::Migration
  def change
    create_table :schools do |t|
      t.references :district, null: false, index: true, foreign_key: { on_delete: :restrict }
      t.text :name, null: false
      t.text :address, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
    end
  end
end
