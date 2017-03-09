export default function() {
  this.post('https://formspree.io/**', function() {
    return {
      data: {
        status: 200
      }
    };
  });
  this.passthrough();
}
