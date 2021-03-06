import Ember from 'ember';

export default Ember.Service.extend({
  flashMessages: Ember.inject.service(),
  i18n: Ember.inject.service(),

  setup() {
    let originalHandler = Ember.onerror; // eslint-disable-line

    Ember.onerror = (error) => {
      let errorText = this.get('i18n').t('flashes.error.generic');
      this.get('flashMessages').error(errorText, { sticky: true });

      if (originalHandler) {
        originalHandler(error);
      } else {
        throw error;
      }
    };
  }
});
