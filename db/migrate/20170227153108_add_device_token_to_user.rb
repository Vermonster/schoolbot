class AddDeviceTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :device_token, :text, limit: 64
  end
end
