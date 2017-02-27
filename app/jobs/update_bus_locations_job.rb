require 'push_notification_service'

class UpdateBusLocationsJob < ActiveJob::Base
  def perform(district)
    @district = district

    zonar.bus_events_since(last_event_time).each do |attributes|
      identifier = attributes.delete(:bus_identifier)
      bus = district.buses.find_or_create_by!(identifier: identifier)
      bus
        .bus_locations
        .find_or_initialize_by(recorded_at: attributes.delete(:recorded_at))
        .update!(attributes)
      check_for_notifications(bus)
    end
  end

  private

  def check_for_notifications(bus)
    BusAssignment.where(bus_id: bus.id).each do |assignment|
      fetch_notification_eligible_users(bus, assignment.student_id).each do |user|
        trigger_push_notification(user, assignment.student_id)
      end
    end
  end

  def fetch_notification_eligible_users(bus, student_id)
    User.joins(:students)
        .where(id: student_id)
        .where.not(device_token: nil, latitude: nil, longitude: nil)
        .select { |user| bus.bus_locations.last.near_user(user) <= 1.5 }
  end

  def trigger_push_notification(user, student_id)
    student_name = StudentLabel.find_by(user_id: user.id, student_id: student_id).nickname
    PushNotificationService.send_notification("Bus is coming for #{student_name}", user)
  end

  def last_event_time
    @district.bus_locations.maximum(:recorded_at)
  end

  def zonar
    Zonar.new(
      customer: @district.zonar_customer,
      username: @district.zonar_username,
      password: @district.zonar_password
    )
  end
end
