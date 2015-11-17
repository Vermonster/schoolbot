class ConfirmationMailer < ApplicationMailer
  def confirmation(user)
    I18n.with_locale(user.locale) do
      mail(
        to: user.email,
        subject: t('emails.confirmAccount.subject'),
        body: t('emails.confirmAccount.body',
          user_name: user.name,
          confirmation_url: confirmation_url(user)
        )
      )
    end
  end

  private

  def confirmation_url(user)
    root_url(subdomain: user.district.slug) +
      "confirm?token=#{user.confirmation_token}"
  end
end
