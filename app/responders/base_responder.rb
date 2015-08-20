class BaseResponder < ActionController::Responder
  # Translate error messages using the "api" pseudo-locale
  def json_resource_errors
    previous_locale = I18n.locale
    I18n.locale = :api
    resource.validate # Re-translate errors in case it was already validated
    errors = super
    I18n.locale = previous_locale
    errors
  end
end
