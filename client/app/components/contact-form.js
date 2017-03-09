import Ember from 'ember';

export default Ember.Component.extend({

  contactName: '',
  contactEmail: '',
  contactMessage: '',
  contactRole: '',

  contactSubmitted: false,
  contactErrored: false,

  actions: {
    updateRole(role) {
      this.set('contactRole', role);
    },

    submit() {
      this.set('contactErrored', false);

      if (Ember.isPresent(this.get('contactEmail'))) {

        Ember.$.ajax({
          url: 'https://formspree.io/schoolbot@vermonster.com',
          method: 'POST',
          dataType: 'json',
          data: {
            _replyto: this.get('contactEmail'),
            _subject: `District contact by ${this.get('contactEmail')}`,
            name: this.get('contactName'),
            message: this.get('contactMessage'),
            role: this.get('contactRole')
          }
        }).then(() => {
          this.set('contactSubmitted', true);
        }).catch(() => {
          this.set('contactErrored', true);
        });
      }
    }
  }
});
