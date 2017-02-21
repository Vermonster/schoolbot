class NotificationService
  APP_NAME = "school_bot"

  def initialize(environment, certificate_path, certificate_password, connections = 1)
    @app = Rpush::Apns::App.new
    @app.name = APP_NAME
    @app.certificate = certificate_path
    @app.environment = environment # APNs environment.
    @app.password = certificate_password
    @app.connections = connections
    @app.save!
  end

  def send_notification(message, device_token)
    n = Rpush::Apns::Notification.new
    n.app = Rpush::Apns::App.find_by_name(APP_NAME)
    n.device_token = device_token
    n.alert = message
    n.data = { foo: :bar }
    n.save!
  end
end
