import Ember from 'ember';

export default Ember.Service.extend({
  ajax: Ember.inject.service(),
  i18n: Ember.inject.service(),

  setup() {
    return this.get('ajax').request('/api/translations').then((locales) => {
      Object.keys(locales).forEach((locale) => {
        this.get('i18n').addTranslations(locale, locales[locale]);
      });
    });
  }
});
