import Ember from 'ember';

export default Ember.Controller.extend({
  districts: Ember.inject.service(),

  actions: {
    signOut() {
      this.get('session').invalidate();
    }
  }
});
