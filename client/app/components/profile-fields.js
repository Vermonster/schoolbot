import Ember from 'ember';

export default Ember.Component.extend({
  showingPasswordFields: Ember.computed.reads('model.isNew')
});
