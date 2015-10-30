/* jshint node: true */

module.exports = function(deployTarget) {
  require('dotenv').load();

  var ENV = {
    build: {},
    redis: {
      allowOverwrite: true
    },
    s3: {
      accessKeyId: process.env['AWS_ACCESS_KEY'],
      secretAccessKey: process.env['AWS_SECRET_KEY'],
      bucket: 'omnibus-assets'
    }
  };

  if (deployTarget === 'development') {
    ENV.plugins = ['redis'];
    ENV.build.environment = 'development';
    ENV.redis.revisionKey = '__development__';
    ENV.redis.distDir = function(context) {
      return context.commandOptions.buildDir;
    };
  }

  if (deployTarget === 'staging' || deployTarget === 'production') {
    ENV.build.environment = 'production';
  }

  if (deployTarget === 'staging') {
    ENV.redis.url = process.env['REDIS_URL_STAGING'];
  }

  if (deployTarget === 'production') {
    ENV.redis.url = process.env['REDIS_URL_PRODUCTION'];
  }

  return ENV;
};
