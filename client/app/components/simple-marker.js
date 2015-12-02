import Ember from 'ember';
import MarkerLayer from 'ember-leaflet/components/marker-layer';

export default MarkerLayer.extend({
  iconClass: null,
  object: null,

  lat: Ember.computed.alias('object.latitude'),
  lng: Ember.computed.alias('object.longitude'),

  icon: Ember.computed('iconClass', function() {
    return this.L.divIcon({ iconSize: null, className: this.get('iconClass') });
  })
});
