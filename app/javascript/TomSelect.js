import TomSelect from 'tom-select';

document.addEventListener("turbo:load", () => {
  document.querySelectorAll('.tom-select').forEach((element) => {
    new TomSelect(element);
  });
});
