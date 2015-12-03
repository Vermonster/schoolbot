import Ember from 'ember';
import LeafletMap from 'ember-leaflet/components/leaflet-map';

export default LeafletMap.extend({
  buses: [],
  schools: [],
  user: null,

  maxZoom: 18, // Ensure bounds fitting still works with only one point
  zoomControl: false,
  attributionControl: false,

  isTrackingBuses: true,

  didCreateLayer() {
    this.setTrackingBounds();
    this._super(...arguments);
  },

  // FIXME: This is currently undocumented and may change in new releases
  // https://github.com/miguelcobain/ember-leaflet/issues/11
  _dragstart() {
    this.set('isTrackingBuses', false);
  },

  busLocationsChanged: Ember.observer('buses.@each.lastSeenAt', function() {
    if (this.get('isTrackingBuses')) {
      this.setTrackingBounds();
    }
  }),

  setTrackingBounds() {
    Ember.run.debounce(this, this._setTrackingBounds, 250, true);
  },

  _setTrackingBounds() {
    const bounds = this.L.latLngBounds([]);

    bounds.extend([this.get('user.latitude'), this.get('user.longitude')]);
    this.get('buses').forEach((bus) => {
      bounds.extend([bus.get('latitude'), bus.get('longitude')]);
    });

    this.set('bounds', bounds);
  },

  actions: {
    zoomIn() {
      this.set('isTrackingBuses', false);
      this._layer.zoomIn();
    },

    zoomOut() {
      this.set('isTrackingBuses', false);
      this._layer.zoomOut();
    },

    enableTracking() {
      this.set('isTrackingBuses', true);
      this.setTrackingBounds();
    }
  }
});
