import Ember from 'ember';

export default Ember.Controller.extend({

  dismissAllStudentsAlert: false,
  isOnline: true,

  students: Ember.computed.filterBy('allStudents', 'isNew', false),
  assignedStudents: Ember.computed.filterBy('students', 'isAssigned', true),

  buses: Ember.computed.mapBy('assignedStudents', 'bus'),
  locatedBuses: Ember.computed.filterBy('buses', 'hasLocations', true),
  uniqueBuses: Ember.computed.uniq('locatedBuses'),

  schools: Ember.computed.mapBy('assignedStudents', 'school'),
  uniqueSchools: Ember.computed.uniq('schools'),

  showingAllStudents: Ember.computed('dismissAllStudentsAlert', 'students.@each.isLocated', function() {
    return this.get('students').every((student) => student.get('isLocated')) || this.get('dismissAllStudentsAlert');
  }),

  actions: {
    closeAlert() {
      this.set('dismissAllStudentsAlert', true);
    }
  }

});
