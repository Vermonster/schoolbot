require 'rpush'

class PushNotificationService
  def self.send_notification(message, device_token)
    # TODO: don't do anything if push notification is not setup
    n = Rpush::Apns::Notification.new
    n.app = Rpush::Apns::App.find_by(name: ENV["APN_APP_NAME"])
    n.device_token = device_token
    n.alert = message
    n.data = { foo: :bar }
    n.save!
    Rpush.push
  end
end
