import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  busLocations: DS.hasMany('bus-location', { async: false }),
  students: DS.hasMany('student', { async: false }),

  identifier: DS.attr('string'),

  latitude: Ember.computed.alias('busLocations.firstObject.latitude'),
  longitude: Ember.computed.alias('busLocations.firstObject.longitude'),
  lastSeenAt: Ember.computed.alias('busLocations.firstObject.recordedAt'),

  hasLocations: Ember.computed.notEmpty('busLocations')
});
