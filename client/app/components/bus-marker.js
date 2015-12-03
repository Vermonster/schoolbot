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
      const moment = this.get('moment').moment.bind(this.get('moment'));
      const labels = this.get('model.students').mapBy('abbreviation').sort();

      let extraClass = '';
      let html = labels.map((label) =>
        `<span class="student__abbreviation--bus-marker">${label}</span>`
      ).join('');

      if (this.get('model.lastSeenAt') < moment().subtract(45, 'seconds')) {
        extraClass = 'bus-marker--time-ago';
        html += '<br>' + moment(this.get('model.lastSeenAt')).fromNow();
      }

      return this.L.divIcon({
        html: html,
        iconSize: null,
        className: `bus-marker ${extraClass}`
      });
    }
  )
});
