import Ember from 'ember';
import AuthenticatedRouteMixin from
  'ember-simple-auth/mixins/authenticated-route-mixin';

const POLL_INTERVAL = 3000;

export default Ember.Route.extend(AuthenticatedRouteMixin, {
  i18n: Ember.inject.service(),
  controller: null,
  intercom: Ember.inject.service(),

  afterModel() {
    let { store } = this;
    return Ember.RSVP.all([
      store.findAll('student').then((students) => this.students = students),
      store.find('user', 'current').then((user) => this.currentUser = user)
    ]);
  },

  setupController(controller) {
    this.set('controller', controller);
    controller.set('allStudents', this.students);
    controller.set('currentUser', this.currentUser);
    this.get('i18n').set('locale', this.currentUser.get('locale'));

    this.get('intercom').boot({
      user: this.currentUser,
      district: this.get('currentDistrict.model')
    });
  },

  pollTask: null,
  poll() {
    this.store.findAll('student', { reload: true })
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
