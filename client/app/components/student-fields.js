import Ember from 'ember';
import moment from 'moment';
/* global jsSHA */

const inputDateFormat = 'M/D/YYYY';

export default Ember.Component.extend({
  birthdate: '',
  birthdateIsValid: true,
  identifier: '',
  lastName: '',
  nickname: '',
  school: null,

  schools: [],

  digester: Ember.observer('birthdate', 'identifier', 'lastName', function() {
    const digestTarget = [
      this.get('identifier'),
      this.get('lastName'),
      moment(this.get('birthdate'), inputDateFormat).format('YYYY-MM-DD')
    ].join(':').toLowerCase();

    const digester = new jsSHA('SHA-256', 'TEXT');
    digester.update(digestTarget);
    this.set('digest', digester.getHash('HEX'));
  }),

  updater: Ember.observer('digest', 'nickname', 'school', function() {
    const fields = {
      digest: this.get('digest'),
      nickname: this.get('nickname'),
      school: this.get('school')
    };

    this.sendAction('update', fields);
    return fields;
  }),

  actions: {
    validateBirthdate() {
      if (Ember.isPresent(this.get('birthdate'))) {
        const parsedDate = moment(this.get('birthdate'), inputDateFormat);
        if (parsedDate.isValid()) {
          this.set('birthdate', parsedDate.format(inputDateFormat));
          this.set('birthdateIsValid', true);
        } else {
          this.set('birthdateIsValid', false);
        }
      }
    }
  }
});
