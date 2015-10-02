import Ember from 'ember';
import ApplicationRouteMixin from 'simple-auth/mixins/application-route-mixin';
import moment from 'moment';

export default Ember.Route.extend(ApplicationRouteMixin, {
  districts: Ember.inject.service(),
  i18n: Ember.inject.service(),
  sessionStorage: Ember.inject.service(),
  translations: Ember.inject.service(),

  beforeModel() {
    this._super(...arguments);

    const storedLocale = this.get('sessionStorage.locale');
    if (Ember.isPresent(storedLocale)) {
      moment.locale(storedLocale);
      this.get('i18n').set('locale', storedLocale);
    }

    return this.get('districts').setup().then((district) => {
      if (district) { return this.get('translations').setup(); }
    });
  }
});
