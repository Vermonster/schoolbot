// Copy of the "local-storage" store that uses sessionStorage instead. See:
// https://github.com/simplabs/ember-simple-auth/blob/master/addon/session-stores/local-storage.js

import Ember from 'ember';
import BaseStore from 'ember-simple-auth/session-stores/base';
import objectsAreEqual from 'ember-simple-auth/utils/objects-are-equal';

const { on } = Ember;

export default BaseStore.extend({
  key: 'ember_simple_auth:session',

  _setup: on('init', function() {
    this._bindToStorageEvents();
  }),

  persist(data) {
    data = JSON.stringify(data || {});
    sessionStorage.setItem(this.key, data);
    this._lastData = this.restore();
  },

  restore() {
    let data = sessionStorage.getItem(this.key);
    return JSON.parse(data) || {};
  },

  clear() {
    sessionStorage.removeItem(this.key);
    this._lastData = {};
  },

  _bindToStorageEvents() {
    Ember.$(window).bind('storage', () => {
      let data = this.restore();
      if (!objectsAreEqual(data, this._lastData)) {
        this._lastData = data;
        this.trigger('sessionDataUpdated', data);
      }
    });
  }
});
