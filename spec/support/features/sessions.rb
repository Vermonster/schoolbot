module Sessions
  def sign_in_as(user)
    use_subdomain(user.district.slug)
    visit root_path
    click_on t('actions.signIn')
    fill_in t('labels.email'), with: user.email
    fill_in t('labels.password'), with: user.password
    click_on t('actions.signIn')
  end
end
