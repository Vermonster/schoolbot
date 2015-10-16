import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  districts: Ember.inject.service(),
  districtName: Ember.computed.alias('districts.current.name'),
  schools: Ember.computed.alias('districts.current.schools'),

  registration: null,
  setup: Ember.on('init', function() {
    this.set('registration', this.get('store').createRecord('registration'));
  }),

  actions: {
    updateStudent(attributes) {
      this.get('registration').setProperties(attributes);
    },

    register() {
      this.get('registration').save().then(() => {
        this.get('session')
          .authenticate('simple-auth-authenticator:devise', {
            identification: this.get('registration.email'),
            password: this.get('registration.password')
          });
      }).catch((error) => {
        if (this.get('registration.isValid')) {
          // TODO: Handle errors with the sign-in rather than the registration
          Ember.onerror(error);
        }
      });
    }
  }
});
