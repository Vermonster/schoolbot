module.exports = function(environment) {
  var requiredEnvironmentVariables = [
    'CLIENT_AIRBRAKE_ID',
    'CLIENT_AIRBRAKE_KEY',
    'CLIENT_MAPBOX_ACCESS_TOKEN',
    'CLIENT_MAPBOX_STYLE_ID',
    'CLIENT_MAPBOX_USERNAME'
  ];

  if (environment === 'production') {
    requiredEnvironmentVariables.forEach(function(variable) {
      if (!process.env[variable]) {
        throw new Error('Required environment variable missing: ' + variable);
      }
    });
  }

  var ENV = {
    modulePrefix: 'client',
    environment: environment,
    rootURL: '/',
    locationType: 'auto',
    'ember-cli-mirage' : {
      enabled: false
    },
    'ember-simple-auth': {
      authenticationRoute: 'sign-in'
    },
    flashMessageDefaults: {
      timeout: 5000,
      types: ['success', 'error']
    },
    i18n: {
      defaultLocale: 'en',
      allowLocaleOverride: true
    },
    intercom: {
      appId: process.env.CLIENT_INTERCOM_ID
    },
    mapbox: {
      username: process.env.CLIENT_MAPBOX_USERNAME,
      styleId: process.env.CLIENT_MAPBOX_STYLE_ID,
      accessToken: process.env.CLIENT_MAPBOX_ACCESS_TOKEN
    },
    moment: { includeLocales: true },

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
    },

  };

  if (environment === 'development') {
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;
    ENV['ember-cli-mirage'] = {
      enabled: true
    }
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
    ENV['ember-cli-mirage'] = {
      enabled: true
    }
  }

  if (environment === 'production') {
    ENV.airbrake = {
      projectId: process.env.CLIENT_AIRBRAKE_ID,
      projectKey: process.env.CLIENT_AIRBRAKE_KEY
    };
  }

  return ENV;
};
