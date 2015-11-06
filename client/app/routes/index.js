import Ember from 'ember';

export default Ember.Route.extend({
  districts: Ember.inject.service(),
  session: Ember.inject.service(),

  beforeModel() {
    if (this.get('districts.current') && this.get('session.isAuthenticated')) {
      this.transitionTo('map');
    }
  }
});
