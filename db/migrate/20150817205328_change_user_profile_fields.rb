class ChangeUserProfileFields < ActiveRecord::Migration
  def change
    remove_column :users, :first_name, :text
    remove_column :users, :last_name, :text
    remove_column :users, :street_address, :text
    remove_column :users, :city, :text
    remove_column :users, :zip_code, :text

    add_column :users, :name, :text, null: false
    add_column :users, :street, :text, null: false
    add_column :users, :city, :text, null: false
    add_column :users, :state, :text, null: false
    add_column :users, :zip_code, :text, null: false
    add_column :users, :latitude, :float, null: false
    add_column :users, :longitude, :float, null: false
  end
end
