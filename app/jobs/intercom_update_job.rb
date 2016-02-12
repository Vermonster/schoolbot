class IntercomUpdateJob < ActiveJob::Base
  ACTIONS = %w(update_user destroy_user update_district)

  def perform(action, *arguments)
    if action.in?(ACTIONS)
      __send__(action, *arguments)
    else
      raise ArgumentError, "'#{action}' is not a valid Intercom action"
    end
  end

  private

  def update_user(user)
    intercom.users.create(
      user_id: user.id,
      email: user.email,
      name: user.name,
      signed_up_at: user.created_at,
      companies: [{ company_id: user.district_id }],
      custom_attributes: custom_user_attributes(user)
    )
  end

  def destroy_user(user_id)
    intercom_user = intercom.users.find(user_id: user_id)
    intercom.users.delete(intercom_user)
  end

  def update_district(district)
    intercom.companies.create(
      company_id: district.id,
      name: district.name,
      remote_created_at: district.created_at,
      custom_attributes: custom_district_attributes(district)
    )
  end

  def custom_user_attributes(user)
    {
      'Confirmed' => !user.confirmed_at.nil?,
      'Students' => user.student_labels.count
    }
  end

  def custom_district_attributes(district)
    {
      'Active' => district.is_active,
      'Buses' => district.buses.count,
      'Schools' => district.schools.count,
      'Students' => district.students.count
    }
  end

  def intercom
    @_intercom ||= Intercom::Client.new(
      app_id: ENV.fetch('INTERCOM_ID'),
      api_key: ENV.fetch('INTERCOM_API_KEY')
    )
  end
end
