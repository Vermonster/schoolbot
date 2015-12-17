require 'rails_helper'

feature 'User edits student' do
  scenario 'with a new first name and school assignment' do
    district = create(:district)
    old_school = create(:school, district: district, name: 'Sometown Middle')
    new_school = create(:school, district: district, name: 'Othertown High')
    user = create(:user, district: district)
    create(:student_label, nickname: 'Jen', user: user, school: old_school)
    create(:student_label, nickname: 'Jeff', user: user, school: new_school)
    sign_in_as user

    click_on t('settings.title')
    within('li', text: 'Jen') do
      click_on t('actions.editStudent')
      fill_in t('labels.nickname'), with: 'Jan'
      select 'Othertown High', from: t('labels.school')
      click_on t('actions.save')
    end

    within('li', text: 'Jan') do
      expect(page).to_not have_field t('labels.nickname')
      expect(page).to have_css '.student__nickname', text: 'Ja'
      expect(page).to have_content 'Othertown High'
    end
  end

  scenario 'and sees an error if they delete the nickname' do
    district = create(:district)
    user = create(:user, district: district)
    create(:student_label, user: user)
    sign_in_as user

    click_on t('settings.title')
    click_on t('actions.editStudent')
    fill_in t('labels.nickname'), with: ''
    click_on t('actions.save')

    expect(page).to have_button t('actions.save')
    expect(page).to have_content t('errors.nickname.blank')
  end

  scenario 'and sees a generic message when an unhandled error occurs' do
    mock_api_failure(:students, :update)
    district = create(:district)
    user = create(:user, district: district)
    create(:student_label, user: user)
    sign_in_as user

    click_on t('settings.title')
    click_on t('actions.editStudent')

    ignoring_ember_errors do
      click_on t('actions.save')
      expect(page).to have_content t('flashes.error.generic')
    end
  end
end
