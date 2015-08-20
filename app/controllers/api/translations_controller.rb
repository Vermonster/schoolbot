module API
  class TranslationsController < BaseController
    def show
      translations = (I18n.available_locales - [:api]).map do |locale|
        [locale, I18n.t('.', locale: locale)]
      end.to_h

      respond_with translations
    end
  end
end
