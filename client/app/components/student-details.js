import Ember from 'ember';

export default Ember.Component.extend({
  tagName: '',

  schools: Ember.computed.alias('currentDistrict.model.schools'),
  schoolOrdering: ['name'],
  orderedSchools: Ember.computed.sort('schools', 'schoolOrdering'),

  student: null,

  isEditing: false,

  actions: {
    edit() {
      this.set('isEditing', true);
    },

    setSchool(id) {
      this.get('student').set('school', this.get('schools').findBy('id', id));
    },

    cancel() {
      // TODO: Roll back the `school` association.
      // https://github.com/emberjs/data/pull/4361
      this.get('student').rollbackAttributes();
      this.set('isEditing', false);
    },

    save() {
      return this.get('student').save().then(() => {
        this.set('isEditing', false);
      }).catch((error) => {
        if (this.get('student.isValid')) {
          Ember.onerror(error);
        }
      });
    }
  }
});
