class AddMissingTimestamps < ActiveRecord::Migration
  def change
    change_table(:schools) { |t| t.timestamps null: false }
    change_table(:student_labels) { |t| t.timestamps null: false }
    change_table(:students) { |t| t.timestamps null: false }
  end
end
