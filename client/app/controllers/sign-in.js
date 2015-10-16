import Ember from 'ember';

export default Ember.Controller.extend({
  i18n: Ember.inject.service(),

  actions: {
    signIn() {
      const credentials = this.getProperties('identification', 'password');
      this.get('session')
        .authenticate('simple-auth-authenticator:devise', credentials)
        .catch((response) => {
          if (response.error) {
            this.set('errorMessage', this.get('i18n').t(response.error));
          } else {
            Ember.onerror(response);
          }
        });
    }
  }
});
