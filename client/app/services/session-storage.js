import Ember from 'ember';

export default Ember.Service.extend({
  unknownProperty(key) {
    return sessionStorage.getItem(key);
  },

  setUnknownProperty(key, value) {
    if (value != null) {
      sessionStorage.setItem(key, value);
    } else {
      sessionStorage.removeItem(key);
    }

    this.notifyPropertyChange(key);
    return value;
  }
});
