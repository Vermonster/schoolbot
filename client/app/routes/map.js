import Ember from 'ember';
import AuthenticatedRoute from 'simple-auth/mixins/authenticated-route-mixin';

const POLL_INTERVAL = 3000;

export default Ember.Route.extend(AuthenticatedRoute, {
  controller: null,

  afterModel() {
    const store = this.store;
    return Ember.RSVP.all([
      store.findAll('student').then((students) => this.students = students),
      store.find('user', 'current').then((user) => this.currentUser = user)
    ]);
  },

  setupController(controller) {
    this.set('controller', controller);
    controller.set('allStudents', this.students);
    controller.set('currentUser', this.currentUser);
  },

  pollTask: null,
  poll() {
    this.store.findAll('student')
      .then(() => this.set('controller.isOnline', true))
      .catch(() => this.set('controller.isOnline', false));
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
