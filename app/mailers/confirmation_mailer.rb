class ConfirmationMailer < ApplicationMailer
  def confirmation(user)
    # TODO: Translate into locale based on what the user selected in Ember
    mail(
      to: user.email,
      subject: t('emails.confirmAccount.subject', locale: :en),
      body: t('emails.confirmAccount.body',
        locale: :en,
        user_name: user.name,
        confirmation_url: confirmation_url(user)
      )
    )
  end

  private

  def confirmation_url(user)
    root_url(subdomain: user.district.slug) +
      "confirm?token=#{user.confirmation_token}"
  end
end
