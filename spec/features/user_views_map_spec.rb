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

  context 'with multiple bus positions' do
    before do
      @first_bus = create(:bus, district: @district)
      second_bus = create(:bus, district: @district)
      create(:bus_location, bus: @first_bus, latitude: 42.01)
      create(:bus_location, bus: second_bus, latitude: 42.02)
      create(:bus_assignment, student: @first_label.student, bus: @first_bus)
      create(:bus_assignment, student: @second_label.student, bus: second_bus)
    end

    scenario 'indicated by student abbreviations' do
      sign_in_as @user

      within('.leaflet-container') do
        expect(page).to have_css('.bus-marker', count: 2)
        expect(page).to have_css('.bus-marker', text: 'FI')
        expect(page).to have_css('.bus-marker', text: 'SE')
      end
    end

    scenario 'live-updated as locations change' do
      sign_in_as @user

      first_bus_style = page.find('.bus-marker', text: 'FI')[:style]
      second_bus_style = page.find('.bus-marker', text: 'SE')[:style]

      create(:bus_location, bus: @first_bus, latitude: 42.03)

      expect(page).to_not have_css(
        %(.bus-marker[style="#{first_bus_style}"]), wait: 5
      )
      expect(page).to have_css(%(.bus-marker[style="#{second_bus_style}"]))
    end
  end

  scenario 'with one marker per bus if students are on the same bus' do
    bus = create(:bus, district: @district)
    create(:bus_location, bus: bus)
    create(:bus_assignment, student: @first_label.student, bus: bus)
    create(:bus_assignment, student: @second_label.student, bus: bus)

    sign_in_as @user

    expect(page).to have_css('.bus-marker', count: 1, text: 'FISE')
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

  scenario 'with time information displayed for outdated bus positions' do
    bus = create(:bus, district: @district)
    create(:bus_location, bus: bus, recorded_at: 1.minute.ago)
    create(:bus_assignment, student: @first_label.student, bus: bus)

    sign_in_as @user

    expect(page).to have_css('.bus-marker', text: 'a minute ago')
  end

  scenario 'with no time information displayed for up-to-date bus positions' do
    bus = create(:bus, district: @district)
    create(:bus_location, bus: bus, recorded_at: 30.seconds.ago)
    create(:bus_assignment, student: @first_label.student, bus: bus)

    sign_in_as @user

    expect(page).to_not have_css('.bus-marker', text: 'ago')
  end

  scenario 'with a marker displayed at their home location' do
    sign_in_as @user

    expect(page).to have_css('.home-marker')
  end

  scenario 'with markers displayed at the school locations of their students' do
    bus = create(:bus, district: @district)
    create(:bus_assignment, student: @first_label.student, bus: bus)
    create(:bus_assignment, student: @second_label.student, bus: bus)

    sign_in_as @user

    expect(page).to have_css('.school-marker', count: 2)
  end

  scenario 'with school markers not displayed for unassigned students' do
    bus = create(:bus, district: @district)
    create(:bus_assignment, student: @first_label.student, bus: bus)

    sign_in_as @user

    expect(page).to have_css('.school-marker', count: 1)
  end
end
