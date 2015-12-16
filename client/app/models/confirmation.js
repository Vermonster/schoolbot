import DS from 'ember-data';

export default DS.Model.extend({
  token: DS.attr('string'),
  userEmail: DS.attr('string'),
  userToken: DS.attr('string'),
  isReconfirmation: DS.attr('boolean')
});
