import Ember from 'ember';
import ApplicationRouteMixin from
  'ember-simple-auth/mixins/application-route-mixin';

export default Ember.Route.extend(ApplicationRouteMixin, {
  dataPreload: Ember.inject.service(),
  i18n: Ember.inject.service(),
  moment: Ember.inject.service(),
  onError: Ember.inject.service(),
  session: Ember.inject.service(),
  translations: Ember.inject.service(),

  beforeModel() {
    this.get('onError').setup();
    this.get('dataPreload').setup();
    this.ios.init();
    let storedLocale = this.get('session.data.locale');
    if (Ember.isPresent(storedLocale)) {
      this.get('moment').changeLocale(storedLocale);
      this.get('i18n').set('locale', storedLocale);
    }

    if (this.get('currentDistrict.isPresent') || this.get('ios.isMobileApp')) {
      return this.get('translations').setup();
    } else if (this.get('currentDistrict.isInvalid')) {
      this.replaceWith('index');
    }
  },

  // When tokens are outdated or invalid on iOS they need to be wiped from cache
  // with ios.logOut()
  sessionInvalidated() {
    this.ios.logout();
    this.transitionTo('sign-in');
  }
});
