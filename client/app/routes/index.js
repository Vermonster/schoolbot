import Ember from 'ember';

export default Ember.Route.extend({
  model: function() {
    return this.store.findRecord('district', 'current').catch(() => {
      this.transitionTo('about');
    });
  }
});
