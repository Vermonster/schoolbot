import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    toggleProfile: function() {
      this.toggleProperty('showingProfile');
    },

    toggleAddStudent: function() {
      this.toggleProperty('showingAddStudentForm');
    }
  }
});
