import Ember from 'ember';
import AuthenticatedRoute from 'simple-auth/mixins/authenticated-route-mixin';

const POLL_INTERVAL = 3000;

export default Ember.Route.extend(AuthenticatedRoute, {
  districts: Ember.inject.service(),

  beforeModel() {
    if (!this.get('districts.current')) {
      this.transitionTo('about');
    } else {
      this._super(...arguments);
    }
  },

  afterModel() {
    this.students = this.store.findAll('student');
    return this.students;
  },

  setupController(controller) {
    controller.set('students', this.students);
  },

  pollTask: null,
  poll() {
    this.store.findAll('student');
    this.set('pollTask', Ember.run.later(this, this.poll, POLL_INTERVAL));
  },

  actions: {
    didTransition() {
      this.set('pollTask', Ember.run.later(this, this.poll, POLL_INTERVAL));
    },

    willTransition() {
      Ember.run.cancel(this.get('pollTask'));
    }
  }
});
