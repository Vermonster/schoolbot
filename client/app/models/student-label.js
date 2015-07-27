import DS from 'ember-data';

export default DS.Model.extend({
  school: DS.belongsTo('school'),
  user: DS.belongsTo('user'),

  nickname: DS.attr('string')
});
