import Ember from 'ember';

export default Ember.Service.extend({
  statusBar(message) {
    sendMessage("statusBar_" + message);
  },

  login() {
    sendMessage("login");
  }

});

function sendMessage(message) {
  if (window.webkit != undefined) {
    window.webkit.messageHandlers.callback.postMessage(message);
  }
}
