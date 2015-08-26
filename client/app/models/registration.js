import DS from 'ember-data';
import User from 'client/models/user';

export default User.extend({
  school: DS.belongsTo('school'),

  digest: DS.attr('string'),
  nickname: DS.attr('string'),
  termsAccepted: DS.attr('boolean')
});
