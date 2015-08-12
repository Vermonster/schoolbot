import Ember from 'ember';

export default Ember.Controller.extend({
  actions: {
    signIn() {
      const credentials = this.getProperties('identification', 'password');
      this.get('session')
        .authenticate('simple-auth-authenticator:devise', credentials)
        .catch((response) => {
          this.set('errorMessage', response.error);
        });
    }
  }
});
