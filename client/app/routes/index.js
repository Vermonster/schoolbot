import Ember from 'ember';
import ResetScrollMixin from './mixins/reset-scroll';

export default Ember.Route.extend(ResetScrollMixin, {
  session: Ember.inject.service(),

  beforeModel() {
    if ((this.get('currentDistrict.isPresent') || this.get('ios.isMobileApp')) &&
        this.get('session.isAuthenticated')) {
          this.transitionTo('map');
    }
  }

});
