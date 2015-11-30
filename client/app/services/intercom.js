/* jshint camelcase: false */
import Ember from 'ember';
import config from 'client/config/environment';

export default Ember.Service.extend({
  boot({ user, students, district }) {
    window.Intercom('boot',
      Ember.merge(
        this._bootParams({ user, students, district }),
        this._updateParams({ user, students })
      )
    );
  },

  update({ user, students }) {
    window.Intercom('update', this._updateParams({ user, students }));
  },

  trackEvent(eventName, metadata = {}) {
    window.Intercom('trackEvent', eventName, metadata);
  },

  shutdown() {
    window.Intercom('shutdown');
  },

  _bootParams({ user, students, district }) {
    return {
      app_id: config.intercom.appId,
      user_id: user.get('id'),
      user_hash: user.get('intercomHash'),
      created_at: user.get('createdAt').getTime() / 1000,
      companies: [{
        company_id: district.get('id'),
        name: district.get('name'),
        remote_created_at: district.get('createdAt').getTime() / 1000
      }]
    };
  },

  _updateParams({ user, students }) {
    return {
      name: user.get('name'),
      email: user.get('email'),
      'Students': students.get('length')
    };
  }
});
