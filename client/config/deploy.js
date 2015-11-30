/* jshint node: true */

module.exports = function(deployTarget) {
  // Load plain .env for common values (.env.deploy.<target> is auto-loaded)
  require('dotenv').load();

  var ENV = {
    build: {},
    redis: {
      allowOverwrite: true
    },
    s3: {
      accessKeyId: process.env['AWS_ACCESS_KEY'],
      secretAccessKey: process.env['AWS_SECRET_KEY'],
      bucket: process.env['AWS_BUCKET'],
      region: process.env['AWS_REGION']
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
    ENV.redis.url = process.env['REDIS_URL'];
  }

  return ENV;
};
