import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "results" ]

  connect() {
    console.log("Autocomplete controller connected")
  }

  search() {
    const query = this.inputTarget.value
    if (query.length < 2) {
      this.resultsTarget.innerHTML = ""
      return
    }

    fetch(`/messages/autocomplete?q=${encodeURIComponent(query)}`, {
      headers: { "Accept": "text/html" }
    })
      .then(response => response.text())
      .then(html => {
        this.resultsTarget.innerHTML = html
      })
  }
}