import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  districts: Ember.inject.service(),
  schools: Ember.computed.alias('districts.current.schools'),

  student: null,
  setup: Ember.on('init', function() {
    this.set('student', this.get('store').createRecord('student'));
  }),

  actions: {
    update(attributes) {
      this.get('student').setProperties(attributes);
    },

    save() {
      this.get('student').save().then(() => {
        this.sendAction('saved');
      }).catch((error) => {
        if (this.get('student.isValid')) {
          // TODO: Handle non-validation errors
          throw new Error(error);
        }
      });
    },

    cancel() {
      this.get('student').deleteRecord();
      this.sendAction('canceled');
    }
  }
});
