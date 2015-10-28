import Ember from 'ember';

export default Ember.Controller.extend({
  isOnline: true,
  students: Ember.computed.filterBy('allStudents', 'isNew', false),

  showingAllStudents: Ember.computed('students.@each.isLocated', function() {
    return this.get('students').every(student => student.get('isLocated'));
  })
});
