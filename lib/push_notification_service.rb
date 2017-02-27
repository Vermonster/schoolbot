require 'rpush'

class PushNotificationService
  def self.send_notification(message, user)
    n = Rpush::Apns::Notification.new
    n.app = Rpush::Apns::App.find_by(name: ENV["APN_APP_NAME"])
    n.device_token = user.device_token
    n.user_id = user.id
    n.alert = message
    n.save!
    Rpush.push
  end
end
