export function initialize(application) {
  ['route', 'controller', 'component'].forEach((type) => {
    application.inject(type, 'currentDistrict', 'service:current-district');
  });
}

export default {
  initialize,
  name: 'current-district'
};
