import Ember from 'ember';

export default Ember.Controller.extend({
  i18n: Ember.inject.service(),
  session: Ember.inject.service(),

  actions: {
    signIn() {
      const { email, password } = this.getProperties('email', 'password');
      this.get('session')
        .authenticate('authenticator:token', email, password)
        .catch((response) => {
          if (response && response.error) {
            this.set('errorMessage', this.get('i18n').t(response.error));
          } else {
            Ember.onerror(response);
          }
        });
    }
  }
});
