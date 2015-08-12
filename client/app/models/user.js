import DS from 'ember-data';

export default DS.Model.extend({
  email: DS.attr('string'),
  password: DS.attr('string'),
  passwordConfirmation: DS.attr('string'),
  firstName: DS.attr('string'),
  lastName: DS.attr('string'),
  streetAddress: DS.attr('string'),
  city: DS.attr('string'),
  zipCode: DS.attr('string')
});
