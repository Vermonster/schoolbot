import DS from 'ember-data';
import DataAdapterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';

export default DS.ActiveModelAdapter.extend(DataAdapterMixin, {
  namespace: 'api',
  authorizer: 'authorizer:token',

  // Always reload all models when `findAll` is used. This is currently the
  // default behavior, but that will change in Ember 2.0, so not having the
  // function defined gives deprecation warnings.
  shouldReloadAll: () => true
});
