import Ember from 'ember';

// FIXME: DO NOT MERGE THIS UNDER ANY CIRCUMSTANCES, IT IS TERRIBLE

export function initialize() {
  Ember.Router.reopen({
    metrics: Ember.inject.service(),

    didTransition() {
      this._super(...arguments);

      Ember.run.scheduleOnce('afterRender', this, () => {
        this.get('metrics').trackPage({
          page: document.location.href,
          title: this.getWithDefault('routeName', 'unknown')
        });
      });
    }
  });

  Ember.ActionHandler.reopen({
    metrics: Ember.inject.service(),

    send(actionName) {
      this._super(...arguments);

      Ember.run.scheduleOnce('afterRender', this, () => {
        this.get('metrics').trackEvent({
          category: 'action',
          action: actionName
        });
      });
    }
  });

  Ember.Component.reopen({
    instrumentActions: Ember.on('init', function() {
      if (!this.actions) { return; }
      const blacklist = ['update', 'updateStudent', 'validateBirthdate'];

      Object.keys(this.actions).forEach((actionName) => {
        const originalAction = this.actions[actionName];

        if (blacklist.indexOf(actionName) === -1) {
          this.actions[actionName] = function() {
            Ember.run.scheduleOnce('afterRender', this, () => {
              this.get('metrics').trackEvent({
                category: 'action',
                action: actionName
              });
            });

            return originalAction.apply(this, arguments);
          };
        }
      });
    })
  });
}

export default {
  name: 'metrics-setup',
  initialize: initialize
};
