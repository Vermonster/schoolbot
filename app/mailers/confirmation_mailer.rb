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

  def reconfirmation(user)
    I18n.with_locale(user.locale) do
      mail(
        to: user.unconfirmed_email,
        subject: t('emails.confirmEmail.subject'),
        body: t('emails.confirmEmail.body',
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
