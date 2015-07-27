class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.references :district, null: false, index: true, foreign_key: { on_delete: :restrict }
      t.string :hash, null: false
    end
  end
end
