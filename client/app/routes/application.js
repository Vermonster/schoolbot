import Ember from 'ember';
import ApplicationRouteMixin from 'simple-auth/mixins/application-route-mixin';
import { translationMacro as t } from 'ember-i18n';
import moment from 'moment';

export default Ember.Route.extend(ApplicationRouteMixin, {
  districts: Ember.inject.service(),
  i18n: Ember.inject.service(),
  localStorage: Ember.inject.service(),
  translations: Ember.inject.service(),

  title: t('titles.application'),

  beforeModel() {
    this._super(...arguments);

    const storedLocale = this.get('localStorage.locale');
    if (Ember.isPresent(storedLocale)) {
      moment.locale(storedLocale);
      this.get('i18n').set('locale', storedLocale);
    }

    return Ember.RSVP.all([
      this.get('districts').setup(),
      this.get('translations').setup()
    ]);
  }
});
