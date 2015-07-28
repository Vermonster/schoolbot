import DS from 'ember-data';

export default DS.Model.extend({
  school: DS.belongsTo('school'),

  nickname: DS.attr('string')
});
