/* global require, module */
var EmberApp = require('ember-cli/lib/broccoli/ember-app');

module.exports = function(defaults) {
  require('dotenv').load();

  // https://github.com/ember-cli/ember-cli/pull/2164#issuecomment-57570584
  // https://github.com/ember-cli/ember-cli-deploy#fingerprinting-options--staging-environments

  var env = EmberApp.env();
  var isProductionLikeBuild = ['production', 'staging'].indexOf(env) > -1;

  var app = new EmberApp(defaults, {
    fingerprint: {
      enabled: isProductionLikeBuild,
      prepend: process.env.ASSET_URL_BASE,
      extensions: ['js', 'css', 'png', 'jpg', 'gif', 'map', 'svg', 'eot', 'otf', 'ttf', 'woff', 'woff2']
    },
    sourcemaps: {
      enabled: !isProductionLikeBuild,
    },
    minifyCSS: { enabled: isProductionLikeBuild },
    minifyJS: { enabled: isProductionLikeBuild },

    tests: process.env.EMBER_CLI_TEST_COMMAND || !isProductionLikeBuild,
    hinting: process.env.EMBER_CLI_TEST_COMMAND || !isProductionLikeBuild,

    // https://github.com/martndemus/ember-cli-font-awesome/issues/33
    emberCliFontAwesome: { includeFontAwesomeAssets: false }
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
