import Ember from 'ember';

export default Ember.Controller.extend({
  isSent: false,

  actions: {
    send() {
      return this.get('model').save().then(() => {
        this.set('isSent', true);
      }).catch((error) => {
        if (this.get('model.isValid')) {
          Ember.onerror(error);
        }
      });
    }
  }
});
