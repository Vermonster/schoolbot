import Ember from 'ember';

export default Ember.Service.extend({

  isMobileApp: Ember.computed(function() {
    return navigator.userAgent.match(/(schoolbot)/) != undefined;
  }),

  statusBar(message) {
    sendMessage(`statusBar_${message}`);
  },

  login() {
    sendMessage('login');
  },

  init() {
    sendMessage('init');
  },

  logout() {
    sendMessage('logout');
  }

});

function sendMessage(message) {
  if (window.webkit != undefined) {
    window.webkit.messageHandlers.callback.postMessage(message);
  }
}
