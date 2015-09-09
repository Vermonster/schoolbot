import Ember from 'ember';
import { request } from 'ic-ajax';

export default Ember.Component.extend({
  districtContactEmail: '',
  districtContactInFlight: false,
  districtContactSubmitted: false,
  districtContactErrored: false,

  actions: {
    submitDistrictContact() {
      this.set('districtContactErrored', false);

      if (Ember.isPresent(this.get('districtContactEmail'))) {
        this.set('districtContactInFlight', true);

        request({
          url: 'https://formspree.io/schoolbot-contact@vermonster.com',
          method: 'POST',
          dataType: 'json',
          data: {
            _replyto: this.get('districtContactEmail'),
            _subject: 'District contact by ' + this.get('districtContactEmail')
          }
        }).then(() => {
          this.set('districtContactSubmitted', true);
        }).catch(() => {
          this.set('districtContactErrored', true);
        }).finally(() => {
          this.set('districtContactInFlight', false);
        });
      }
    }
  }
});
