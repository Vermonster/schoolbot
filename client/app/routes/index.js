import Ember from 'ember';
import AuthenticatedRoute from 'simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRoute, {
  districts: Ember.inject.service(),

  beforeModel: function() {
    if (!this.get('districts.current')) {
      this.transitionTo('about');
    } else {
      this._super(...arguments);
    }
  }

});
