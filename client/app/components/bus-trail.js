import Ember from 'ember';
import PolylineLayer from 'ember-leaflet/components/polyline-layer';

export default PolylineLayer.extend({
  model: null,

  locations: Ember.computed('model.busLocations.[]', function() {
    return this.get('model.busLocations').map((location) => {
      return { lat: location.get('latitude'), lng: location.get('longitude') };
    });
  })
});
