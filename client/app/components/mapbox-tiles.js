import env from 'client/config/environment';
import Ember from 'ember';
import TileLayer from 'ember-leaflet/components/tile-layer';

export default TileLayer.extend({
  url: Ember.computed(function() {
    const suffix = this.L.Browser.retina ? '@2x' : '';

    return `https://api.mapbox.com/v4/${env.mapbox.mapId}` +
      `/{z}/{x}/{y}${suffix}.png?access_token=${env.mapbox.accessToken}`;
  })
});
