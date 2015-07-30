class ChangeStringColumnsToText < ActiveRecord::Migration
  def up
    change_column :users, :email, :text, null: false, default: ''
    change_column :users, :encrypted_password, :text, null: false, default: ''
    change_column :users, :authentication_token, :text, null: false
    change_column :users, :reset_password_token, :text
    change_column :users, :unlock_token, :text
    change_column :users, :first_name, :text
    change_column :users, :last_name, :text
    change_column :users, :street_address, :text
    change_column :users, :city, :text
    change_column :users, :zip_code, :text
    change_column :students, :digest, :text, null: false
    change_column :student_labels, :nickname, :text, null: false
  end

  def down
    change_column :users, :email, :string, null: false, default: ''
    change_column :users, :encrypted_password, :string, null: false, default: ''
    change_column :users, :authentication_token, :string, null: false
    change_column :users, :reset_password_token, :string
    change_column :users, :unlock_token, :string
    change_column :users, :first_name, :string
    change_column :users, :last_name, :string
    change_column :users, :street_address, :string
    change_column :users, :city, :string
    change_column :users, :zip_code, :string
    change_column :students, :digest, :string, null: false
    change_column :student_labels, :nickname, :string, null: false
  end
end
