import Ember from 'ember';
import UnauthenticatedRouteMixin from
  'ember-simple-auth/mixins/unauthenticated-route-mixin';

export default Ember.Route.extend(UnauthenticatedRouteMixin, {
  flashMessages: Ember.inject.service(),
  i18n: Ember.inject.service(),

  model(params, transition) {
    return this.store
      .findRecord('passwordReset', transition.queryParams.token)
      .catch(() => {
        // TODO: Handle 404s differently from other failures?
        let message = this.get('i18n').t('flashes.error.invalidReset');
        this.get('flashMessages').error(message, { sticky: true });
        this.transitionTo('reset-password');
      });
  }
});
