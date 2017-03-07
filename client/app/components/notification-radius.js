import Ember from 'ember';
import CircleLayer from 'ember-leaflet/components/circle-layer';

export default CircleLayer.extend({
  home: null,

  lat: Ember.computed.alias('home.latitude'),
  lng: Ember.computed.alias('home.longitude'),
  className: 'notification-radius',
  radius: Ember.computed.alias('home.notificationRadius')
});
