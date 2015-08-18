import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    toggleSettings() {
      this.toggleProperty('showingSettings');
    },

    toggleAddStudent() {
      this.toggleProperty('showingAddStudentForm');
    },

    signOut: function() {
      this.get('session').invalidate();
    }
  }
});
