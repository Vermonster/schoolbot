import Ember from 'ember';

export default Ember.Service.extend({
  flashMessages: Ember.inject.service(),
  i18n: Ember.inject.service(),

  setup() {
    const originalHandler = Ember.onerror;

    Ember.onerror = (error) => {
      const errorText = this.get('i18n').t('flashes.error.generic');
      this.get('flashMessages').error(errorText, { sticky: true });

      if (originalHandler) {
        originalHandler(error);
      } else {
        // Work around PhantomJS not reacting well to re-thrown errors (?)
        if (window._phantom) {
          Ember.Logger.error(error);
        } else {
          throw error;
        }
      }
    };
  }
});
