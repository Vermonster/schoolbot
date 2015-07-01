import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  contactPhone: DS.attr('string'),
  contactEmail: DS.attr('string')
});
