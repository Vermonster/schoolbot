import Ember from 'ember';
import config from 'client/config/environment';

export default Ember.Service.extend({

  intercom: Ember.computed('window.Intercom', function() {
    return window.Intercom || Ember.K;
  }),

  boot({ user, district }) {
    /* eslint-disable camelcase */

    this.get('intercom')('boot', {
      app_id: config.intercom.appId,
      user_id: user.get('id'),
      name: user.get('name'),
      email: user.get('email'),
      user_hash: user.get('intercomHash'),
      language_override: user.get('locale'),
      companies: [{
        company_id: district.get('id'),
        name: district.get('name')
      }]
    });

    /* eslint-enable camelcase */
  },

  trackEvent(eventName) {
    let eventAttribute = Ember.String.camelize(eventName);
    if (!this.get(eventAttribute))  {
      this.get('intercom')('trackEvent', eventName);
      this.set(eventAttribute, true);
    }
  },

  shutdown() {
    this.get('intercom')('shutdown');
  }
});
