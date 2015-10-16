import Ember from 'ember';

export default Ember.Controller.extend({
  map: Ember.inject.controller(),
  user: Ember.computed.alias('map.currentUser'),
  studentOrdering: ['nickname'],
  students: Ember.computed.sort('map.students', 'studentOrdering'),

  showingStudentForm: false,
  showingProfileForm: false,

  actions: {
    toggleAddStudent() {
      this.toggleProperty('showingStudentForm');
    },

    toggleEditProfile() {
      this.get('user').rollbackAttributes();
      this.toggleProperty('showingProfileForm');
    },

    updateProfile() {
      this.get('user').save().then(() => {
        // Update auth data in-place so the session stays valid
        // TODO: Send a link to the new address instead, forcing re-auth
        this.get('session.secure').email = this.get('user.email');
        this.send('toggleEditProfile');
      }).catch((error) => {
        if (this.get('user.isValid')) {
          Ember.onerror(error);
        }
      });
    },

    signOut() {
      this.get('session').invalidate();
    }
  }
});
