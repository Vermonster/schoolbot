import Ember from 'ember';

export default Ember.Service.extend({
  unknownProperty: function(key) {
    return localStorage.getItem(key);
  },

  setUnknownProperty: function(key, value) {
    if (value != null) {
      localStorage.setItem(key, value);
    } else {
      localStorage.removeItem(key);
    }

    this.notifyPropertyChange(key);
    return value;
  }
});
