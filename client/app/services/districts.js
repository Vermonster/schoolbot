import Ember from 'ember';

export default Ember.Service.extend({
  store: Ember.inject.service(),

  setup: function(){
    return this.get('store').findRecord('district', 'current')
      .then((district) => this.set('current', district))
      .catch(() => null);
  },

  current: null
});
