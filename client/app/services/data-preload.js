import Ember from 'ember';

export default Ember.Service.extend({
  store: Ember.inject.service(),

  setup() {
    this.get('store').pushPayload(JSON.parse(window.dataPreload));
  }
});
