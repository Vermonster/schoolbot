import Ember from 'ember';
import { request } from 'ic-ajax';

export default Ember.Component.extend({
  districtContactEmail: '',
  districtContactInFlight: false,
  districtContactSubmitted: false,
  districtContactErrored: false,

  didInsertElement() {
    // Facebook button setup
    (function(d, s, id) {
      let js, fjs = d.getElementsByTagName(s)[0];
      if (d.getElementById(id)) { return; }
      js = d.createElement(s);
      js.id = id;
      js.src = '//connect.facebook.net/en_US/sdk.js#xfbml=1&version=v2.4';
      fjs.parentNode.insertBefore(js, fjs);
    }(document, 'script', 'facebook-jssdk'));

    // Twitter button setup
    (function(d,s,id){
      let js, fjs = d.getElementsByTagName(s)[0],
        p = /^http:/.test(d.location) ? 'http' : 'https';
      if (!d.getElementById(id)) {
        js = d.createElement(s);
        js.id = id;
        js.src = p + '://platform.twitter.com/widgets.js';
        fjs.parentNode.insertBefore(js, fjs);
      }
    }(document, 'script', 'twitter-wjs'));
  },

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
