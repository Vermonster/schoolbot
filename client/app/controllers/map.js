import Ember from 'ember';

export default Ember.Controller.extend({
  isOnline: true,
  students: Ember.computed.filterBy('allStudents', 'isNew', false)
});
