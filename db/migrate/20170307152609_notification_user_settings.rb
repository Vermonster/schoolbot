class NotificationUserSettings < ActiveRecord::Migration
  def change
    add_column :users, :enable_notifications, :boolean, default: false
    add_column :users, :notification_radius, :float, default: 0.5
    add_column :users, :notification_time_of_day, :string, default: 'day'
    add_column :users, :notification_days, :string, default: 'weekday'
  end
end
