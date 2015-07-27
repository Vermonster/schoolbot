import Ember from 'ember';

export default Ember.Controller.extend({
  districts: Ember.inject.service(),

  actions: {
    toggleProfile: function() {
      this.toggleProperty('showingProfile');
    }
  }
});
