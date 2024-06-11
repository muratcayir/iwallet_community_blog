import "@hotwired/turbo-rails"
import "./controllers"
import "trix"
import "@rails/actiontext"
import LocalTime from "local-time"

import "./custom";
LocalTime.start()

document.addEventListener("turbo:load", () => {
  const searchInput = document.getElementById("search-input");
  const searchResults = document.getElementById("search-results");

  searchInput.addEventListener("input", async () => {
    const query = searchInput.value.trim();
    if (query.length < 3) {
      searchResults.classList.add("hidden");
      searchResults.innerHTML = "";
      return;
    }

    const response = await fetch(`/search_preview?query=${query}`);
    const results = await response.json();

    let resultsHtml = "";

    if (results.tags.length > 0) {
      resultsHtml += "<div class='search-category'>Tags:</div>";
      results.tags.forEach(tag => {
        resultsHtml += `<div class='search-result-item'><a href='/articles?tag=${tag.name}'>${tag.name}</a></div>`;
      });
    }

    if (results.articles.length > 0) {
      resultsHtml += "<div class='search-category'>Articles:</div>";
      results.articles.forEach(article => {
        resultsHtml += `<div class='search-result-item'><a href='/articles/${article.id}'>${article.title}</a></div>`;
      });
    }

    if (results.users.length > 0) {
      resultsHtml += "<div class='search-category'>Users:</div>";
      results.users.forEach(user => {
        resultsHtml += `<div class='search-result-item'><a href='/users/${user.username}'>${user.username}</a></div>`;
      });
    }

    searchResults.innerHTML = resultsHtml;
    searchResults.classList.remove("hidden");
  });
});


