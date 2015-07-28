class CreateStudentLabels < ActiveRecord::Migration
  def change
    create_table :student_labels do |t|
      t.references :student, null: false, index: true, foreign_key: { on_delete: :cascade }
      t.references :school, null: false, index: true, foreign_key: { on_delete: :restrict }
      t.references :user, null: false, index: true, foreign_key: { on_delete: :cascade }
      t.string :nickname, null: false
    end
  end
end
