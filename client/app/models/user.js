import DS from 'ember-data';

export default DS.Model.extend({
  email: DS.attr('string'),
  unconfirmedEmail: DS.attr('string'),
  password: DS.attr('string'),
  passwordConfirmation: DS.attr('string'),
  name: DS.attr('string'),
  street: DS.attr('string'),
  city: DS.attr('string'),
  state: DS.attr('string'),
  zipCode: DS.attr('string'),
  latitude: DS.attr('number'),
  longitude: DS.attr('number'),
  locale: DS.attr('string'),
  intercomHash: DS.attr('string')
});
