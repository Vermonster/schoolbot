import DS from 'ember-data';

export default DS.Model.extend({
  schools: DS.hasMany('school', { async: false }),

  name: DS.attr('string'),
  contactPhone: DS.attr('string'),
  contactEmail: DS.attr('string'),
  logoUrl: DS.attr('string')
});
