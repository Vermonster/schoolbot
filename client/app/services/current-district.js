import Ember from 'ember';

export default Ember.Service.extend({
  store: Ember.inject.service(),

  model: Ember.computed(function() {
    return this.get('store').peekAll('district').get('firstObject');
  }),

  isNone: Ember.computed.equal('model.id', 'none'),
  isInvalid: Ember.computed.equal('model.id', 'invalid'),
  isAbsent: Ember.computed.or('isNone', 'isInvalid'),
  isPresent: Ember.computed.not('isAbsent')
});
