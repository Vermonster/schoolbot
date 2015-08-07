/* globals L: false */

import env from 'client/config/environment';
import LeafletMap from 'ember-leaflet/components/leaflet-map';
import TileLayer from 'ember-leaflet/layers/tile';

// https://www.mapbox.com/help/attribution/
const ATTRIBUTION = [
  '&copy; <a href="https://www.mapbox.com/about/maps/">Mapbox</a>',
  '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors',
  '<a href="https://www.mapbox.com/map-feedback/">Improve this map</a>'
].join(' | ');

export default LeafletMap.extend({
  options: {
    attributionControl: false
  },

  didCreateLayer: function() {
    this._super();
    L.control.attribution({ prefix: false })
      .addAttribution(ATTRIBUTION)
      .addTo(this._layer);
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
    })
  ]
});
