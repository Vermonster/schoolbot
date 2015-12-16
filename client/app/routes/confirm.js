import Ember from 'ember';
import UnauthenticatedRouteMixin from
  'ember-simple-auth/mixins/unauthenticated-route-mixin';

export default Ember.Route.extend(UnauthenticatedRouteMixin, {
  flashMessages: Ember.inject.service(),
  i18n: Ember.inject.service(),
  session: Ember.inject.service(),

  beforeModel(transition) {
    this.get('session').authenticate(
      'authenticator:confirmation-token', transition.queryParams.token
    ).then(() => {
      const isNew = this.get('session.data.authenticated.isNew');
      const flashKey = isNew ? 'accountConfirmed' : 'emailConfirmed';
      const message = this.get('i18n').t(`flashes.success.${flashKey}`);
      this.get('flashMessages').success(message);
      this.transitionTo('map');
    }).catch((error) => {
      if (error) {
        Ember.onerror(error);
      } else {
        const message = this.get('i18n').t('flashes.error.invalidConfirmation');
        this.get('flashMessages').error(message, { sticky: true });
      }
      this.transitionTo('sign-in');
    });
  }
});
