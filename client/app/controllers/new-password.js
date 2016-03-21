import Ember from 'ember';

export default Ember.Controller.extend({
  flashMessages: Ember.inject.service(),
  i18n: Ember.inject.service(),
  session: Ember.inject.service(),

  actions: {
    confirm() {
      return this.get('model').save().then((model) => {
        let { email, password } = model.getProperties('email', 'password');
        return this.get('session')
          .authenticate('authenticator:application', email, password)
          .then(() => {
            let message = this.get('i18n').t('flashes.success.passwordReset');
            this.get('flashMessages').success(message);
          });
      }).catch((error) => {
        if (this.get('model.isValid')) {
          Ember.onerror(error);
        }
      });
    }
  }
});
