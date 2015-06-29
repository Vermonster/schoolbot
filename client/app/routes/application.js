import Ember from 'ember';
import { translationMacro as t } from 'ember-i18n';

export default Ember.Route.extend({
  i18n: Ember.inject.service(),
  title: t('app.name')
});
