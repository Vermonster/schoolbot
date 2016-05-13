/* global require, module */
var EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
  require('dotenv').load();

  var env = EmberApp.env();

  var app = new EmberApp(defaults, {
    fingerprint: {
      prepend: process.env.CLIENT_ASSET_URL_BASE,
      extensions: ['js', 'css', 'png', 'jpg', 'gif', 'map', 'svg', 'eot', 'otf', 'ttf', 'woff', 'woff2']
    },

    emberCLIDeploy: {
      runOnPostBuild: (env === 'development') ? env : false,
      shouldActivate: true
    },

    'ember-font-awesome': {
      // https://github.com/martndemus/ember-font-awesome/issues/64
      includeFontAwesomeAssets: false
    }
  });

  // Use `app.import` to add additional libraries to the generated
  // output files.
  //
  // If you need to use different assets in different
  // environments, specify an object as the first parameter. That
  // object's keys should be the environment name and the values
  // should be the asset to use in that environment.
  //
  // If the library that you are including contains AMD or ES6
  // modules that you would like to import into your application
  // please specify an object with the list of modules as keys
  // along with the exports of each module as its value.

  app.import(app.bowerDirectory + '/jsSHA/src/sha256.js');
  app.import(app.bowerDirectory + '/modernizr/modernizr.custom.js');

  return app.toTree();
};
