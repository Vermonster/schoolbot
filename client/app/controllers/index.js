import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    toggleProfile() {
      this.toggleProperty('showingProfile');
    },

    toggleAddStudent() {
      this.toggleProperty('showingAddStudentForm');
    },

    signOut: function() {
      this.get('session').invalidate();
    }
  }
});
