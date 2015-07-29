class AddMissingUniqueIndexes < ActiveRecord::Migration
  def change
    add_index :students, [:digest, :district_id], unique: true
    add_index :student_labels, [:student_id, :user_id], unique: true
    add_index :student_labels, [:nickname, :user_id], unique: true
  end
end
