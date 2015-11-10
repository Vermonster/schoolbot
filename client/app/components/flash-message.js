import Ember from 'ember';
import FlashMessage from 'ember-cli-flash/components/flash-message';

export default FlashMessage.extend({
  alertType: Ember.computed('flash.type', function() {
    let type = this.get('flash.type');
    return `msg msg--flash msg--${type}`;
  }),

  click: Ember.K, // Default is to dismiss the message when clicked anywhere

  isError: Ember.computed.equal('flash.type', 'error'),

  actions: {
    close() {
      this._destroyFlashMessage();
    }
  }
});
