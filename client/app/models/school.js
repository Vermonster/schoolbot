import DS from 'ember-data';

export default DS.Model.extend({
  district: DS.belongsTo('district'),
  name: DS.attr('string'),
  address: DS.attr('string'),
  latitude: DS.attr('number'),
  longitude: DS.attr('number')
});
