import Ember from 'ember';

export default Ember.Component.extend({
  i18n: Ember.inject.service(),
  moment: Ember.inject.service(),
  session: Ember.inject.service(),

  classNames: ['locale-picker'],

  locales: Ember.computed('i18n.locale', 'i18n.locales', function() {
    return this.get('i18n.locales').map((locale) => {
      return {
        id: locale,
        label: this.get('i18n').t('localeName', { locale })
      };
    });
  }),

  localePicked: Ember.K,

  actions: {
    setLocale(locale) {
      this.get('moment').changeLocale(locale);
      this.get('i18n').set('locale', locale);
      this.get('session').set('data.locale', locale);
      this.sendAction('localePicked');
    }
  }
});
