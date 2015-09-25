import Ember from 'ember';
import moment from 'moment';

export default Ember.Component.extend({
  i18n: Ember.inject.service(),
  sessionStorage: Ember.inject.service(),

  classNames: ['locale-picker'],

  locales: Ember.computed('i18n.locale', 'i18n.locales', function() {
    return this.get('i18n.locales').filter((locale) => {
      return this.get('i18n').exists('locales.' + locale);
    }).map((locale) => {
      return { id: locale, label: this.get('i18n').t('locales.' + locale) };
    });
  }),

  actions: {
    setLocale(locale) {
      moment.locale(locale);
      this.get('i18n').set('locale', locale);
      this.get('sessionStorage').set('locale', locale);
    }
  }
});
