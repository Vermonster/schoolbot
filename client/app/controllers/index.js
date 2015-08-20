import Ember from 'ember';

export default Ember.Controller.extend({
  students: Ember.computed.filterBy('allStudents', 'isNew', false),

  actions: {
    toggleSettings() {
      this.toggleProperty('showingSettings');
    },

    toggleAddStudent() {
      this.toggleProperty('showingStudentForm');
    },

    signOut: function() {
      this.get('session').invalidate();
    }
  }
});
