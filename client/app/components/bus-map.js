/* globals L: false */

import env from 'client/config/environment';
import Ember from 'ember';
import LeafletMap from 'ember-leaflet/components/leaflet-map';
import TileLayer from 'ember-leaflet/layers/tile';
import MarkerLayer from 'ember-leaflet/layers/marker';
import CollectionLayer from 'ember-leaflet/layers/collection';
import PolylineLayer from 'ember-leaflet/layers/polyline';
import CollectionBoundsMixin from 'ember-leaflet/mixins/collection-bounds';
import leafletComputed from 'ember-leaflet/utils/computed';

// https://www.mapbox.com/help/attribution/
const ATTRIBUTION = [
  '&copy; <a href="https://www.mapbox.com/about/maps/">Mapbox</a>',
  '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
  '<a href="https://www.mapbox.com/map-feedback/">Improve this map</a>'
].join(' | ');

const busLocationsPath = 'controller.uniqueBuses.@each.busLocations';

export default LeafletMap.extend({
  students: [],
  assignedStudents: Ember.computed.filterBy('students', 'isAssigned', true),
  buses: Ember.computed.mapBy('assignedStudents', 'bus'),
  locatedBuses: Ember.computed.filterBy('buses', 'hasLocations', true),
  uniqueBuses: Ember.computed.uniq('locatedBuses'),

  options: {
    attributionControl: false
  },

  didCreateLayer() {
    this._super();
    L.control.attribution({ prefix: false })
      .addAttribution(ATTRIBUTION)
      .addTo(this.get('layer'));
  },

  childLayers: [
    TileLayer.extend({
      tileUrl: 'https://api.mapbox.com/v4/{mapId}' +
        '/{z}/{x}/{y}{suffix}.png?access_token={accessToken}',
      options: {
        suffix: L.Browser.retina ? '@2x' : '',
        mapId: env.mapbox.mapId,
        accessToken: env.mapbox.accessToken
      }
    }),

    CollectionLayer.extend(CollectionBoundsMixin, {
      itemLayerClass: MarkerLayer.extend({
        icon: leafletComputed.optionProperty(),
        options: Ember.computed('content.labels', function() {
          return {
            icon: L.divIcon({
              html: this.get('content.labels').join(' | '),
              iconSize: null,
              className: 'bus-marker'
            })
          };
        })
      }),

      didCreateLayer() {
        this._super();
        // TODO: Higher-level default bound that takes the user's home address
        // and school addresses into account
        if (this.get('bounds')) {
          this.get('parentLayer').get('layer').fitBounds(this.get('bounds'));
        }
      },

      content: Ember.computed(busLocationsPath, function() {
        return this.get('controller.uniqueBuses').map((bus) => {
          const latLng = bus
            .get('busLocations.firstObject')
            .getProperties('latitude', 'longitude');

          return {
            location: L.latLng(latLng.latitude, latLng.longitude),
            labels: bus.get('students').mapBy('nicknameAbbrev').sort()
          };
        });
      })
    }),

    CollectionLayer.extend({
      itemLayerClass: PolylineLayer,

      content: Ember.computed(busLocationsPath, function() {
        return this.get('controller.uniqueBuses').map((bus) => {
          return bus.get('busLocations').map((busLocation) => {
            return L.latLng(
              busLocation.get('latitude'),
              busLocation.get('longitude')
            );
          });
        });
      })
    })
  ]
});
