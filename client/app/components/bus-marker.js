import Ember from 'ember';
import MarkerLayer from 'ember-leaflet/components/marker-layer';

export default MarkerLayer.extend({
  moment: Ember.inject.service(),

  model: null,

  lat: Ember.computed.alias('model.busLocations.firstObject.latitude'),
  lng: Ember.computed.alias('model.busLocations.firstObject.longitude'),
  clickable: false,
  keyboard: false,

  icon: Ember.computed(
    'moment.locale',
    'model.lastSeenAt',
    'model.students.@each.abbreviation',
    function() {
      let moment = this.get('moment').moment.bind(this.get('moment'));
      let students = this.get('model.students').sortBy('nickname');

      let extraClass = '';
      let html = students.map((student) => {
        return `<span
          class='bus-marker__student-abbreviation'
          data-index='${student.get('index')}'>
            ${student.get('abbreviation')}
          </span>`;
      }).join('');

      if (this.get('model.lastSeenAt') < moment().subtract(45, 'seconds')) {
        extraClass = 'bus-marker--time-ago';
        html += `<br>${moment(this.get('model.lastSeenAt')).fromNow()}`;
      }

      return this.L.divIcon({
        html,
        iconSize: null,
        className: `bus-marker ${extraClass}`
      });
    }
  )
});
