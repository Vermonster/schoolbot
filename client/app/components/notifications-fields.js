import Ember from 'ember';

export default Ember.Component.extend({
  times: ['morning', 'afternoon'],

  selectedTimes: [],

  actions: {
    selectTime(event) {
      let selectedTimes = Ember.$(event.target).val();
      this.set('selectedTimess', selectedTimes || []);
    }
  }
});
