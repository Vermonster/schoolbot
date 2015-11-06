/* jshint node: true */

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'client',
    environment: environment,
    baseURL: '/',
    locationType: 'auto',
    flashMessageDefaults: {
      types: ['success', 'error']
    },
    i18n: {
      defaultLocale: 'en',
      allowLocaleOverride: true
    },
    moment: { includeLocales: true },
    'ember-simple-auth': {
      authenticationRoute: 'sign-in'
    },
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
      },
      LOG_VERSION: false
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
    }
  };

  if (!process.env.MAPBOX_MAP_ID || !process.env.MAPBOX_ACCESS_TOKEN) {
    if (environment === 'production') {
      throw new Error('MAPBOX_MAP_ID and MAPBOX_ACCESS_TOKEN must be defined!');
    } else {
      console.log('Warning: MAPBOX_MAP_ID or MAPBOX_ACCESS_TOKEN not defined!');
    }
  }

  ENV.mapbox = {
    mapId: process.env.MAPBOX_MAP_ID,
    accessToken: process.env.MAPBOX_ACCESS_TOKEN
  }

  if (environment === 'development') {
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.baseURL = '/';
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
  }

  if (environment === 'production') {
    if (!process.env.AIRBRAKE_ID || !process.env.AIRBRAKE_KEY) {
      throw new Error('AIRBRAKE_ID and AIRBRAKE_KEY must be defined in .env!');
    }

    ENV.airbrake = {
      projectId: process.env.AIRBRAKE_ID,
      projectKey: process.env.AIRBRAKE_KEY
    };
  }

  return ENV;
};
