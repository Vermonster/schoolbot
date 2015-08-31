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
    const store = this.store;
    return Ember.RSVP.all([
      store.findAll('student').then((students) => this.students = students),
      store.find('user', 'current').then((user) => this.currentUser = user)
    ]);
  },

  setupController(controller) {
    controller.set('allStudents', this.students);
    controller.set('currentUser', this.currentUser);
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
