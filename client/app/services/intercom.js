/* jshint camelcase: false */
import Ember from 'ember';
import config from 'client/config/environment';

export default Ember.Service.extend({
  intercom: window.Intercom || Ember.K,

  boot({ user, district }) {
    this.intercom('boot', {
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
  },

  shutdown() {
    this.intercom('shutdown');
  }
});
