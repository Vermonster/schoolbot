import Ember from 'ember';

export default Ember.Controller.extend({
  students: Ember.computed.filterBy('allStudents', 'isNew', false),

  showingMapMsg: true
});
