module API
  class TranslationsController < BaseController
    def show
      translations = I18n.available_locales.map { |locale|
        if I18n.exists?('localeName', locale)
          [locale, I18n.t('.', locale: locale)]
        end
      }.compact.to_h

      respond_with translations
    end
  end
end
