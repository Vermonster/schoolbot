import Ember from 'ember';

export default Ember.Controller.extend({
  i18n: Ember.inject.service(),
  session: Ember.inject.service(),
  intercom: Ember.inject.service(),
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
      return this.get('user').save().then(() => {
        // Update auth data in-place so the session stays valid
        // FIXME: Remove once email confirmation is implemented
        this.get('session.data.authenticated').email = this.get('user.email');
        this.send('toggleEditProfile');
      }).catch((error) => {
        if (this.get('user.isValid')) {
          Ember.onerror(error);
        }
      });
    },

    updateLocale() {
      this.get('user').set('locale', this.get('i18n.locale'));
      this.get('user').save();
    },

    signOut() {
      this.get('intercom').shutdown();
      this.get('session').invalidate();
    }
  }
});
