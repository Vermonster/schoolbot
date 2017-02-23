import Ember from 'ember';
import AuthenticatedRouteMixin from 'ember-simple-auth/mixins/authenticated-route-mixin';

export default Ember.Route.extend(AuthenticatedRouteMixin, {

  activate() {
    this.ios.statusBar('hide');
  },

  deactivate() {
    this.ios.statusBar('show');
  }

});
