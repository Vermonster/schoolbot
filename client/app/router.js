import Ember from 'ember';
import config from './config/environment';

let Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('map', function() {
    this.route('help');
    this.route('settings');
  });

  this.route('confirm');
  this.route('register');
  this.route('reset-password');
  this.route('sign-in');

  this.route('privacy');
  this.route('terms');
});

export default Router;
