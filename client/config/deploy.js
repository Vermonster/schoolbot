/* jshint node: true */

require('dotenv').load();

module.exports = {
  development: {
    buildEnv: 'development'
  },

  staging: {
    buildEnv: 'staging',
    store: process.env['REDIS_URL_STAGING'],
    assets: {
      accessKeyId: process.env['AWS_ACCESS_KEY'],
      secretAccessKey: process.env['AWS_SECRET_KEY'],
      bucket: 'omnibus-assets'
    }
  },

  production: {
    store: process.env['REDIS_URL_PRODUCTION'],
    assets: {
      accessKeyId: process.env['AWS_ACCESS_KEY'],
      secretAccessKey: process.env['AWS_SECRET_KEY'],
      bucket: 'omnibus-assets'
    }
  }
}
