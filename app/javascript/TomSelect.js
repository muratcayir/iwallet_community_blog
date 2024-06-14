import TomSelect from 'tom-select';

document.addEventListener("turbo:load", () => {
  new TomSelect('.tom-select', {
    plugins: ['remove_button'],
    create: false,
    load: function(query, callback) {
      var url = '/tags/search?query=' + encodeURIComponent(query);
      fetch(url)
        .then(response => response.json())
        .then(data => {
          callback(data);
        }).catch(() => {
          callback();
        });
    }
  });
});
