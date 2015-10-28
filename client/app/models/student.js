import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  bus: DS.belongsTo('bus', { async: false }),
  school: DS.belongsTo('school', { async: false }),

  digest: DS.attr('string'),
  nickname: DS.attr('string'),

  isAssigned: Ember.computed.notEmpty('bus'),
  isLocated: Ember.computed.alias('bus.hasLocations'),

  // TODO: Calculate the shortest distinct abbreviation among all nicknames?
  abbreviation: Ember.computed('nickname', function() {
    return this.get('nickname').substr(0, 2).toUpperCase();
  })
});
