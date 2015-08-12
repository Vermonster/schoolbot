import Ember from 'ember';
import AuthenticatedRoute from 'simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRoute, {
  districts: Ember.inject.service(),

  beforeModel: function() {
    if (!this.get('districts.current')) {
      this.transitionTo('about');
    } else {
      this._super(...arguments);
    }
  },

  afterModel: function() {
    this.students = this.store.findAll('student');
    return this.students;
  },

  setupController: function(controller) {
    controller.set('students', this.students);
  }
});
