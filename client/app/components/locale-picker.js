import Ember from 'ember';
import moment from 'moment';

export default Ember.Component.extend({
  i18n: Ember.inject.service(),
  localStorage: Ember.inject.service(),

  classNames: ['locale-picker'],

  locales: Ember.computed('i18n.locale', 'i18n.locales', function() {
    return this.get('i18n.locales').filter((locale) => {
      return this.get('i18n').exists('locales.' + locale);
    }).map((locale) => {
      return { id: locale, label: this.get('i18n').t('locales.' + locale) };
    });
  }),

  currentLabel: Ember.computed('i18n.locale', function() {
    return this.get('i18n').t('locales.' + this.get('i18n.locale'));
  }),

  isOpen: false,

  actions: {
    toggle() { this.toggleProperty('isOpen'); },

    setLocale(locale) {
      moment.locale(locale);
      this.get('i18n').set('locale', locale);
      this.get('localStorage').set('locale', locale);
      this.send('toggle');
    }
  }
});
