import Ember from 'ember';
import MarkerLayer from 'ember-leaflet/components/marker-layer';

export default MarkerLayer.extend({
  iconClass: null,
  iconSize: null,
  object: null,

  lat: Ember.computed.alias('object.latitude'),
  lng: Ember.computed.alias('object.longitude'),
  clickable: false,
  keyboard: false,

  didInsertElement: function() {
    this._super()
    //Fix offset by Height and Width defined in Styles
    Ember.run.scheduleOnce('afterRender', this, function() {
      var el = document.getElementsByClassName(this.get('iconClass'))[0]
      this.set('iconSize', [el.clientHeight, el.clientWidth])
    })
  },
  icon: Ember.computed('iconClass', 'iconSize', function() {
    return this.L.divIcon({ iconSize: this.get('iconSize'), className: this.get('iconClass') });
  })
});
