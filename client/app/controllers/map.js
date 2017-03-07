import Ember from 'ember';

export default Ember.Controller.extend({
  isOnline: true,

  students: Ember.computed.filterBy('allStudents', 'isNew', false),
  assignedStudents: Ember.computed.filterBy('students', 'isAssigned', true),

  buses: Ember.computed.mapBy('assignedStudents', 'bus'),
  locatedBuses: Ember.computed.filterBy('buses', 'hasLocations', true),
  uniqueBuses: Ember.computed.uniq('locatedBuses'),

  schools: Ember.computed.mapBy('assignedStudents', 'school'),
  uniqueSchools: Ember.computed.uniq('schools'),

  // Current support for IOS, so only where device token is set
  canEditNotifications: Ember.computed('user.device_token', function() {
    // should be !! instead of !
    return !this.get('user.device_token');
  }),

  showingNotificationRadius: Ember.computed('canEditNotifications', 'currentUser.enableNotifications', function() {
    return this.get('canEditNotifications') && this.get('currentUser.enableNotifications');
  }),
  showingAllStudents: Ember.computed('students.@each.isLocated', function() {
    return this.get('students').every((student) => student.get('isLocated'));
  })
});
