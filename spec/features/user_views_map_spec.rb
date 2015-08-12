require 'rails_helper'

feature 'User views map' do
  before do
    @district = create(:district)
    @user = create(:user, district: @district)
    @first_label = create(:student_label,
      school: create(:school, district: @district),
      student: create(:student, district: @district),
      user: @user,
      nickname: 'First'
    )
    @second_label = create(:student_label,
      school: create(:school, district: @district),
      student: create(:student, district: @district),
      user: @user,
      nickname: 'Second'
    )
  end

  scenario 'with bus positions indicated by student abbreviations' do
    first_bus = create(:bus, district: @district)
    second_bus = create(:bus, district: @district)
    create(:bus_location, bus: first_bus)
    create(:bus_location, bus: second_bus)
    create(:bus_assignment, student: @first_label.student, bus: first_bus)
    create(:bus_assignment, student: @second_label.student, bus: second_bus)

    sign_in_as @user

    within('.leaflet-container') do
      expect(page).to have_css('.bus-marker', count: 2)
      expect(page).to have_css('.bus-marker', text: 'FI')
      expect(page).to have_css('.bus-marker', text: 'SE')
    end
  end

  scenario 'with one marker per bus if students are on the same bus' do
    bus = create(:bus, district: @district)
    create(:bus_location, bus: bus)
    create(:bus_assignment, student: @first_label.student, bus: bus)
    create(:bus_assignment, student: @second_label.student, bus: bus)

    sign_in_as @user

    within('.leaflet-container') do
      expect(page).to have_css('.bus-marker', count: 1, text: 'FI | SE')
    end
  end

  scenario 'with markers displayed only for buses that have locations' do
    first_bus = create(:bus, district: @district)
    second_bus = create(:bus, district: @district)
    create(:bus_location, bus: first_bus)
    create(:bus_assignment, student: @first_label.student, bus: first_bus)
    create(:bus_assignment, student: @second_label.student, bus: second_bus)

    sign_in_as @user

    expect(page).to have_css('.bus-marker', count: 1, text: 'FI')
  end

  scenario 'with markers displayed only for students assigned to a bus' do
    bus = create(:bus, district: @district)
    create(:bus_location, bus: bus)
    create(:bus_assignment, student: @second_label.student, bus: bus)

    sign_in_as @user

    expect(page).to have_css('.bus-marker', count: 1, text: 'SE')
  end
end
