class AddUserToRpushNotifications < ActiveRecord::Migration
  def change
    add_reference :rpush_notifications, :user, index: true, foreign_key: true
  end
end
