import Ember from 'ember';

export default Ember.Component.extend({
  i18n: Ember.inject.service(),
  localStorage: Ember.inject.service(),

  classNames: ['locale-picker'],

  locales: Ember.computed('i18n.locale', 'i18n.locales', function() {
    return this.get('i18n.locales').map((locale) => {
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
      this.get('i18n').set('locale', locale);
      this.get('localStorage').set('locale', locale);
      this.send('toggle');
    }
  }
});
