import Ember from 'ember';
import DS from 'ember-data';

export default DS.Model.extend({
  busLocations: DS.hasMany('bus-location'),
  students: DS.hasMany('student'),

  identifier: DS.attr('string'),

  // FIXME: computed.notEmpty does not work here, why?
  hasLocations: Ember.computed('busLocations.[]', function(){
    return this.get('busLocations.length') > 0;
  })
});
