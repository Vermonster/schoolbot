import Ember from 'ember';
import ApplicationRouteMixin from 'simple-auth/mixins/application-route-mixin';
import { translationMacro as t } from 'ember-i18n';

export default Ember.Route.extend(ApplicationRouteMixin, {
  districts: Ember.inject.service(),
  i18n: Ember.inject.service(),
  title: t('app.name'),

  beforeModel: function() {
    this._super(...arguments);
    return this.get('districts').setup();
  }
});
