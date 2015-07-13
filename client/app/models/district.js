import DS from 'ember-data';

export default DS.Model.extend({
  schools: DS.hasMany('school'),
  users: DS.hasMany('user'),

  name: DS.attr('string'),
  contactPhone: DS.attr('string'),
  contactEmail: DS.attr('string')
});
