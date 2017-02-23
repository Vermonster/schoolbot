import Ember from 'ember';

export default Ember.Controller.extend({
  i18n: Ember.inject.service(),
  session: Ember.inject.service(),
  intercom: Ember.inject.service(),
  map: Ember.inject.controller(),
  user: Ember.computed.alias('map.currentUser'),
  students: Ember.computed.alias('map.students'),

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
      this.ios.statusBar('show');
    }
  }
});
