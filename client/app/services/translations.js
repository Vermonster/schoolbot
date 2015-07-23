import Ember from 'ember';
import { request } from 'ic-ajax';

export default Ember.Service.extend({
  i18n: Ember.inject.service(),

  setup: function() {
    return request('/api/translations').then((locales) => {
      Object.keys(locales).forEach((locale) => {
        this.get('i18n').addTranslations(locale, locales[locale]);
      });
    });
  }
});
