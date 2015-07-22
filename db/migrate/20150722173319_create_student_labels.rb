class CreateStudentLabels < ActiveRecord::Migration
  def change
    create_table :student_labels do |t|
      t.integer :user_id, null: false
      t.integer :student_id, null: false
      t.string :nickname, null: false
    end
  end
end
