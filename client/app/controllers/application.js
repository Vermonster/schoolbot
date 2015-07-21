import Ember from 'ember';

export default Ember.Controller.extend({
  districts: Ember.inject.service(),

  actions: {
    signOut: function() {
      this.get('session').invalidate();
    }
  }
});
