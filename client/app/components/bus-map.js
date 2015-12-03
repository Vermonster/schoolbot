import Ember from 'ember';
import LeafletMap from 'ember-leaflet/components/leaflet-map';

export default LeafletMap.extend({
  buses: [],
  schools: [],
  user: null,

  maxZoom: 18, // Ensure bounds fitting still works with only one point
  zoomControl: false,
  attributionControl: false,

  bounds: Ember.computed(function() { return this.trackingBounds(); }),

  trackingBounds() {
    const bounds = this.L.latLngBounds([]);

    bounds.extend([this.get('user.latitude'), this.get('user.longitude')]);
    this.get('buses').forEach((bus) => {
      bounds.extend([bus.get('latitude'), bus.get('longitude')]);
    });

    return bounds;
  },

  actions: {
    zoomIn() { this._layer.zoomIn(); },
    zoomOut() { this._layer.zoomOut(); }
  }
});
