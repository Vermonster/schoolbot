import Ember from 'ember';

export default Ember.Component.extend({
  tagName: '',

  isEditing: false,
  schools: Ember.computed.alias('currentDistrict.model.schools'),
  student: null,

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
