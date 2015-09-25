import Ember from 'ember';
import Base from 'simple-auth/stores/base';
import objectsAreEqual from 'simple-auth/utils/objects-are-equal';

export default Base.extend({
  sessionStorage: Ember.inject.service(),

  init: function() {
    this.key = 'ember_simple_auth:session';
    this.bindToStorageEvents();
  },

  persist: function(data) {
    data = JSON.stringify(data || {});
    this.get('sessionStorage').set(this.key, data);
    this._lastData = this.restore();
  },

  restore: function() {
    const data = this.get('sessionStorage').get(this.key);
    return JSON.parse(data) || {};
  },

  clear: function() {
    this.get('sessionStorage').set(this.key, null);
    this._lastData = {};
  },

  bindToStorageEvents: function() {
    Ember.$(window).bind('storage', () => {
      const data = this.restore();
      if (!objectsAreEqual(data, this._lastData)) {
        this._lastData = data;
        this.trigger('sessionDataUpdated', data);
      }
    });
  }
});
