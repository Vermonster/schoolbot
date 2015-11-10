import Ember from 'ember';

export default Ember.Component.extend({
  session: Ember.inject.service(),
  store: Ember.inject.service(),
  schools: Ember.computed.alias('currentDistrict.model.schools'),

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
        this.sendAction('didRegister', this.get('registration.email'));
      }).catch((error) => {
        if (this.get('registration.isValid')) {
          Ember.onerror(error);
        }
      });
    }
  }
});
