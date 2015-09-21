/* globals L: false */

import env from 'client/config/environment';
import Ember from 'ember';
import moment from 'moment';

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

const currentLocalePath = 'controller.i18n.locale';
const busLocationsPath = 'controller.uniqueBuses.@each.busLocations';

export default LeafletMap.extend({
  i18n: Ember.inject.service(),

  user: null,
  students: [],

  assignedStudents: Ember.computed.filterBy('students', 'isAssigned', true),

  buses: Ember.computed.mapBy('assignedStudents', 'bus'),
  locatedBuses: Ember.computed.filterBy('buses', 'hasLocations', true),
  uniqueBuses: Ember.computed.uniq('locatedBuses'),

  schools: Ember.computed.mapBy('assignedStudents', 'school'),
  uniqueSchools: Ember.computed.uniq('schools'),

  options: {
    attributionControl: false
  },

  didInitAttrs() {
    this.get('i18n'); // https://github.com/jamesarosen/ember-i18n/issues/299
  },

  didCreateLayer() {
    this._super();

    L.control.attribution({ prefix: false })
      .addAttribution(ATTRIBUTION)
      .addTo(this.get('layer'));

    const bounds = L.latLngBounds([]);
    this.get('childLayers').forEach((layer) => {
      if (layer.get('location')) { bounds.extend(layer.get('location')); }
      if (layer.get('bounds')) { bounds.extend(layer.get('bounds')); }
    });
    this.get('layer').fitBounds(bounds);
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

    MarkerLayer.extend({
      content: Ember.computed('controller.user.latitude', function() {
        const user = this.get('controller.user');
        return {
          location: L.latLng(user.get('latitude'), user.get('longitude'))
        };
      }),

      options: {
        icon: L.divIcon({
          iconSize: null,
          className: 'home-marker'
        })
      }
    }),

    CollectionLayer.extend({
      itemLayerClass: MarkerLayer.extend({
        options: {
          icon: L.divIcon({
            iconSize: null,
            className: 'school-marker'
          })
        }
      }),

      content: Ember.computed('controller.uniqueSchools', function() {
        return this.get('controller.uniqueSchools').map((school) => {
          const latLng = school.getProperties('latitude', 'longitude');
          return { location: L.latLng(latLng.latitude, latLng.longitude) };
        });
      })
    }),

    CollectionLayer.extend(CollectionBoundsMixin, {
      itemLayerClass: MarkerLayer.extend({
        icon: leafletComputed.optionProperty(),
        options: Ember.computed('content', function() {
          let html = '';
          let className = '';

          this.get('content.labels').forEach(label =>
            html = html + '<span class="student__abbreviation--bus-marker">' +
                   label + '</span>'
          );

          if (Ember.isPresent(this.get('content.timeAgo'))) {
            html += '<br>' + this.get('content.timeAgo');
            className = 'bus-marker--time-ago';
          }

          return {
            icon: L.divIcon({
              html: html,
              iconSize: null,
              className: 'bus-marker ' + className
            })
          };
        })
      }),

      content: Ember.computed(currentLocalePath, busLocationsPath, function() {
        return this.get('controller.uniqueBuses').map((bus) => {
          const latLng = bus
            .get('busLocations.firstObject')
            .getProperties('latitude', 'longitude');
          const lastRecordedAt = bus.get('busLocations.firstObject.recordedAt');
          let timeAgo = null;
          if (lastRecordedAt < moment().subtract(45, 'seconds')) {
            timeAgo = moment(lastRecordedAt).fromNow();
          }

          return {
            location: L.latLng(latLng.latitude, latLng.longitude),
            labels: bus.get('students').mapBy('abbreviation').sort(),
            timeAgo: timeAgo
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
