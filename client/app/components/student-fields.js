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
    let digestTarget = [
      this.get('identifier'),
      this.get('lastName'),
      moment(this.get('birthdate'), inputDateFormat).format('YYYY-MM-DD')
    ].join(':').toLowerCase();

    let digester = new jsSHA('SHA-256', 'TEXT'); // jscs:ignore requireCapitalizedConstructors
    digester.update(digestTarget);
    this.set('digest', digester.getHash('HEX'));
  }),

  updater: Ember.observer('digest', 'nickname', 'school', function() {
    let fields = {
      digest: this.get('digest'),
      nickname: this.get('nickname'),
      school: this.get('school')
    };

    this.sendAction('update', fields);
    return fields;
  }),

  actions: {
    setSchool(id) {
      this.set('school', this.get('schools').findBy('id', id));
    },

    validateBirthdate() {
      if (Ember.isPresent(this.get('birthdate'))) {
        let parsedDate = moment(this.get('birthdate'), inputDateFormat);
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
