import Ember from 'ember';
import LeafletMap from 'ember-leaflet/components/leaflet-map';

// https://www.mapbox.com/help/attribution/
const ATTRIBUTION = [
  '&copy; <a href="https://www.mapbox.com/about/maps/">Mapbox</a>',
  '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
  '<a href="https://www.mapbox.com/map-feedback/">Improve this map</a>'
].join(' | ');

export default LeafletMap.extend({
  buses: [],
  user: null,

  maxZoom: 18, // Ensure bounds fitting still works with only one point

  attributionControl: false,

  didCreateLayer() {
    this._super(...arguments);

    this.L.control.attribution({ prefix: false, position: 'topright' })
      .addAttribution(ATTRIBUTION)
      .addTo(this._layer);
  },

  bounds: Ember.computed(function() { return this.trackingBounds(); }),

  trackingBounds() {
    const bounds = this.L.latLngBounds([]);

    bounds.extend([this.get('user.latitude'), this.get('user.longitude')]);
    this.get('buses').forEach((bus) => {
      bounds.extend([bus.get('latitude'), bus.get('longitude')]);
    });

    return bounds;
  }
});
