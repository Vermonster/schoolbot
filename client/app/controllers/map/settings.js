import Ember from 'ember';

export default Ember.Controller.extend({
  i18n: Ember.inject.service(),
  session: Ember.inject.service(),
  intercom: Ember.inject.service(),
  map: Ember.inject.controller(),
  user: Ember.computed.alias('map.currentUser'),
  students: Ember.computed.alias('map.students'),

  // Current support for IOS, so only where device token is set
  canEditNotifications: Ember.computed('user.device_token', function() {
    console.log('can edit notifications')
    // should be !! instead of !
    return !this.get('user.device_token');
  }),

  showingStudentForm: false,
  showingNotificationForm: false,
  showingProfileForm: false,

  actions: {
    toggleAddStudent() {
      this.toggleProperty('showingStudentForm');
    },

    toggleEditProfile() {
      this.get('user').rollbackAttributes();
      this.toggleProperty('showingProfileForm');
    },

    toggleEditNotifications() {
      this.get('user').rollbackAttributes();
      this.toggleProperty('showingNotificationForm');
    },

    updateProfile(callbackAction) {
      return this.get('user').save().then(() => {
        this.send(callbackAction);
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
