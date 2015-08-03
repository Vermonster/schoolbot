import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  school: DS.belongsTo('school'),

  nickname: DS.attr('string'),

  // TODO: write a logic to calculate
  // the shortest abbreviation for each nickname
  // It also has to be unique among all nicknames
  nicknameAbbrev: Ember.computed('nickname', function() {
    return this.get('nickname').substr(0, 2).toUpperCase();
  })
});
