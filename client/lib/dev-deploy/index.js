module.exports = {
  name: 'dev-deploy',

  isDevelopingAddon: function() {
    return true;
  },

  postBuild: function(results) {
    var fs = this.project.require('fs-extra');
    var redis = this.project.require('redis').createClient();

    if (process.env.EMBER_ENV === 'development') {
      fs.readFile(results.directory + '/index.html', function(error, content) {
        if (error) throw error;
        redis.set('client:development', content);
        redis.set('client:current', 'client:development');
      });
    }
  }
};
