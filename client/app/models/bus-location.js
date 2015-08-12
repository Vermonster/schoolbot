import DS from 'ember-data';

export default DS.Model.extend({
  bus: DS.belongsTo('bus', { async: false }),

  latitude: DS.attr('number'),
  longitude: DS.attr('number'),
  heading: DS.attr('string'),
  recordedAt: DS.attr('date')
});
