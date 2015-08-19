module Sessions
  def sign_in_as(user)
    use_subdomain(user.district.slug)
    visit root_path
    fill_in 'Your email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'SIGN IN'
  end
end
