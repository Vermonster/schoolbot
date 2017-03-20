import Ember from 'ember';
import AuthenticatedRouteMixin from
  'ember-simple-auth/mixins/authenticated-route-mixin';
import { task, timeout } from 'ember-concurrency';

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
    this.get('pollTask').perform();
    this.set('controller', controller);
    controller.set('allStudents', this.students);
    controller.set('currentUser', this.currentUser);
    this.get('i18n').set('locale', this.currentUser.get('locale'));

    this.get('intercom').boot({
      user: this.currentUser,
      district: this.get('currentDistrict.model')
    });
  },

  resetController(controller, isExiting) {
    if (isExiting) {
      controller.set('dismissAllStudentsAlert', false);
    }
  },

  pollTask: task(function* () {
    while (true) {
      yield timeout(POLL_INTERVAL);
      this.store.findAll('student', { reload: true })
        .then(() => this.set('controller.isOnline', true))
        .catch(() => this.set('controller.isOnline', false));
    }
  }).cancelOn('deactivate').restartable()
});
