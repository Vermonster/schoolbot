import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  bus: DS.belongsTo('bus'),
  school: DS.belongsTo('school'),

  nickname: DS.attr('string'),

  isAssigned: Ember.computed.notEmpty('bus'),

  // TODO: Calculate the shortest distinct abbreviation among all nicknames?
  nicknameAbbrev: Ember.computed('nickname', function() {
    return this.get('nickname').substr(0, 2).toUpperCase();
  })
});
