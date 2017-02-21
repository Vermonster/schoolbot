export function initialize(application) {
  ['route', 'controller'].forEach((type) => {
    application.inject(type, 'ios', 'service:ios-messagehandler');
  });
}

export default {
  initialize,
  name: 'ios'
};
