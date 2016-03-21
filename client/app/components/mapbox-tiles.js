import env from 'client/config/environment';
import Ember from 'ember';
import TileLayer from 'ember-leaflet/components/tile-layer';

export default TileLayer.extend({
  tileSize: 512,
  zoomOffset: -1,

  url: Ember.computed(function() {
    let baseUrl = 'https://api.mapbox.com/styles/v1';
    let suffix = this.L.Browser.retina ? '@2x' : '';

    return `${baseUrl}/${env.mapbox.username}` +
      `/${env.mapbox.styleId}/tiles/{z}/{x}/{y}${suffix}` +
      `?access_token=${env.mapbox.accessToken}`;
  })
});
