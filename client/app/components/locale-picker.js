import Ember from 'ember';

export default Ember.Component.extend({
  i18n: Ember.inject.service(),
  localStorage: Ember.inject.service(),

  // FIXME: https://github.com/jamesarosen/ember-i18n/issues/281
  availableLocales: ['en', 'es'],

  locales: Ember.computed('i18n.locale', function() {
    return this.get('availableLocales').map((locale) => {
      return { id: locale, label: this.get('i18n').t('locales.' + locale) };
    });
  }),

  currentLabel: Ember.computed('i18n.locale', function() {
    return this.get('i18n').t('locales.' + this.get('i18n.locale'));
  }),

  isOpen: false,

  actions: {
    toggle: function() { this.toggleProperty('isOpen'); },

    setLocale: function(locale) {
      this.get('i18n').set('locale', locale);
      this.get('localStorage').set('locale', locale);
      this.send('toggle');
    }
  }
});
