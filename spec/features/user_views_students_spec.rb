require 'rails_helper'

feature 'User views students' do
  before do
    @district = create(:district,
      contact_phone: '555-9876',
      contact_email: 'dist@example.com'
    )
    @user = create(:user, district: @district)
  end

  scenario 'and sees a list of nicknames and schools' do
    first_label = create(:student_label,
      school: create(:school, district: @district, name: 'Middle School'),
      student: create(:student, district: @district),
      user: @user,
      nickname: 'First'
    )
    second_label = create(:student_label,
      school: create(:school, district: @district, name: 'High School'),
      student: create(:student, district: @district),
      user: @user,
      nickname: 'Second'
    )
    bus = create(:bus, district: @district)
    create(:bus_location, bus: bus)
    create(:bus_assignment, student: first_label.student, bus: bus)
    create(:bus_assignment, student: second_label.student, bus: bus)

    sign_in_as @user
    click_on t('settings.title')

    within('section', text: 'MY STUDENTS') do
      within('li', text: 'First') do
        expect(page).to have_css '.student__nickname', text: 'F'
        expect(page).to have_content 'Middle School'
      end
      within('li', text: 'Second') do
        expect(page).to have_css '.student__nickname', text: 'S'
        expect(page).to have_content 'High School'
      end
    end
  end

  scenario 'and sees unique abbreviations for each student nickname' do
    create(:student_label, user: @user, nickname: 'Bobby')
    create(:student_label, user: @user, nickname: 'Benny')
    create(:student_label, user: @user, nickname: 'Berky')

    sign_in_as @user
    click_on t('settings.title')

    expect(page).to have_css '.student__nickname', text: 'Bo'
    expect(page).to have_css '.student__nickname', text: 'Ben'
    expect(page).to have_css '.student__nickname', text: 'Ber'
  end

  scenario 'and sees a message if no recent bus locations are available' do
    label = create(:student_label,
      school: create(:school, district: @district),
      student: create(:student, district: @district),
      user: @user,
      nickname: 'Nicholas'
    )
    bus = create(:bus, district: @district, identifier: 'A123')
    create(:bus_location, bus: bus, recorded_at: 6.minutes.ago)
    create(:bus_assignment, student: label.student, bus: bus)

    sign_in_as @user
    click_on t('settings.title')

    within('li', text: 'Nicholas') do
      # TODO: Reconcile i18n interpolation methods of Rails vs. Ember
      expect(page).to have_content(
        t('settings.students.problems.busOutdated').sub('{{busNumber}}', 'A123')
      )
      click_on t('settings.students.problems.contactDistrict')
    end
    expect(page).to have_content '555-9876'
    expect(page).to have_content 'dist@example.com'
  end

  scenario 'and sees a message if a student is not assigned to a bus' do
    create(:student_label,
      school: create(:school, district: @district),
      student: create(:student, district: @district),
      user: @user,
      nickname: 'Nicholas'
    )

    sign_in_as @user
    click_on t('settings.title')

    within('li', text: 'Nicholas') do
      expect(page).to have_content t('settings.students.problems.notAssigned')
      click_on t('settings.students.problems.contactDistrict')
    end
    expect(page).to have_content '555-9876'
    expect(page).to have_content 'dist@example.com'
  end
end
