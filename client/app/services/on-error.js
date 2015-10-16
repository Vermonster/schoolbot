import Ember from 'ember';

export default Ember.Service.extend({
  flashMessages: Ember.inject.service(),
  i18n: Ember.inject.service(),

  setup() {
    const originalHandler = Ember.onerror || Ember.K;

    Ember.onerror = (error) => {
      const errorText = this.get('i18n').t('flashes.error.generic');
      this.get('flashMessages').error(errorText, { sticky: true });

      originalHandler(error);
    };
  }
});
