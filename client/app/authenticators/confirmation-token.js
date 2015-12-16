import Ember from 'ember';
import ApplicationAuthenticator from 'client/authenticators/application';

export default ApplicationAuthenticator.extend({
  store: Ember.inject.service(),

  authenticate(confirmationToken) {
    return new Ember.RSVP.Promise((resolve, reject) => {
      const confirmation = this.get('store').createRecord(
        'confirmation',
        { token: confirmationToken }
      );

      confirmation.save().then(() => {
        resolve({
          email: confirmation.get('userEmail'),
          token: confirmation.get('userToken'),
          isNew: !confirmation.get('isReconfirmation')
        });
      }).catch((error) => {
        if (confirmation.get('isValid')) {
          reject(error);
        } else {
          reject(null);
        }
      });
    });
  }
});
