module.exports = function(deployTarget) {
  var ENV = {
    build: {},
    redis: {
      allowOverwrite: true
    },
    s3: {
      accessKeyId: process.env['CLIENT_AWS_ACCESS_KEY'],
      secretAccessKey: process.env['CLIENT_AWS_SECRET_KEY'],
      bucket: process.env['CLIENT_AWS_BUCKET'],
      region: process.env['CLIENT_AWS_REGION']
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
    ENV.redis.url = process.env['CLIENT_REDIS_URL'];
  }

  return ENV;
};
