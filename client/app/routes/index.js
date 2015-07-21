import Ember from 'ember';

export default Ember.Route.extend({
  districts: Ember.inject.service(),

  beforeModel: function() {
    if (!this.get('districts.current')) {
      this.transitionTo('about');
    }
  }
});
