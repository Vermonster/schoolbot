import Ember from 'ember';

export default Ember.Controller.extend({
  isCompleted: false,
  registeredEmail: null,

  actions: {
    didRegister(email) {
      this.set('registeredEmail', email);
      this.toggleProperty('isCompleted');
    }
  }
});
