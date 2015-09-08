import Ember from 'ember';
import config from './config/environment';

let Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('map');
  this.route('register');
  this.route('sign-in');
});

export default Router;
