import Ember from 'ember';
import config from './config/environment';
import googlePageview from './mixins/google-pageview';

let Router = Ember.Router.extend(googlePageview, {
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
  this.route('map', function() {
    this.route('help');
    this.route('settings');
  });

  this.route('confirm');
  this.route('new-password');
  this.route('register');
  this.route('reset-password');
  this.route('sign-in');

  this.route('privacy');
  this.route('terms');

  this.route('notFound', { path: '*anything' });
});

export default Router;
