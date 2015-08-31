import Ember from 'ember';

export default Ember.Controller.extend({
  students: Ember.computed.filterBy('allStudents', 'isNew', false),

  showingSettings: false,
  showingStudentForm: false,
  showingProfileForm: false,

  actions: {
    toggleSettings() {
      this.toggleProperty('showingSettings');
    },

    toggleAddStudent() {
      this.toggleProperty('showingStudentForm');
    },

    toggleEditProfile() {
      this.get('currentUser').rollbackAttributes();
      this.toggleProperty('showingProfileForm');
    },

    updateProfile() {
      this.get('currentUser').save().then(() => {
        // Update auth data in-place so the session stays valid
        // TODO: Send a link to the new address instead, forcing re-auth
        this.get('session.secure').email = this.get('currentUser.email');
        this.send('toggleEditProfile');
      }).catch((error) => {
        if (this.get('currentUser.isValid')) {
          // TODO: Handle non-validation errors
          throw new Error(error);
        }
      });
    },

    signOut() {
      this.get('session').invalidate();
    }
  }
});
