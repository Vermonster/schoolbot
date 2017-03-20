import Ember from 'ember';

export default Ember.Controller.extend({

  studentsAlertDismissed: false,
  isOnline: true,

  students: Ember.computed.filterBy('allStudents', 'isNew', false),
  assignedStudents: Ember.computed.filterBy('students', 'isAssigned', true),

  buses: Ember.computed.mapBy('assignedStudents', 'bus'),
  locatedBuses: Ember.computed.filterBy('buses', 'hasLocations', true),
  uniqueBuses: Ember.computed.uniq('locatedBuses'),

  schools: Ember.computed.mapBy('assignedStudents', 'school'),
  uniqueSchools: Ember.computed.uniq('schools'),

  studentsAlertActive: Ember.computed('studentsAlertDismissed', 'students.@each.isLocated', function() {
    return this.get('students').every((student) => student.get('isLocated')) || !this.get('studentsAlertDismissed');
  }),

  actions: {
    closeAlert() {
      this.set('studentsAlertDismissed', true);
    }
  }

});
