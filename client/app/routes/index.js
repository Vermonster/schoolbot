import Ember from 'ember';

export default Ember.Route.extend({
  session: Ember.inject.service(),

  beforeModel() {
    if (
      this.get('currentDistrict.isPresent') &&
      this.get('session.isAuthenticated')
    ) {
      this.transitionTo('map');
    }
  }
});
