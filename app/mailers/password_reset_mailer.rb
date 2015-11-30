class PasswordResetMailer < ApplicationMailer
  def password_reset(user)
    I18n.with_locale(user.locale) do
      mail(
        to: user.email,
        subject: t('emails.resetPassword.subject'),
        body: t('emails.resetPassword.body',
          user_name: user.name,
          password_reset_url: password_reset_url(user)
        )
      )
    end
  end

  private

  def password_reset_url(user)
    root_url(subdomain: user.district.slug) +
      "new-password?token=#{user.reset_password_token}"
  end
end
