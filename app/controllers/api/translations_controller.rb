module API
  class TranslationsController < BaseController
    skip_before_action :authenticate_user!

    def show
      translations = I18n.available_locales.map do |locale|
        [locale, I18n.t('.', locale: locale)]
      end.to_h

      respond_with translations
    end
  end
end
