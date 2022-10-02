import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["query", "results"]
  connect() {
  }

  search() {
    let query = this.queryTarget.value
    let results = this.resultsTarget
    if(query.length > 0) {
      const csrfToken = document.querySelector("[name='csrf-token']").content
      fetch(`fighter/none/search/${query}`, {
          headers: { accept: "text/vnd.turbo-stream.html", "X-CSRF-Token": csrfToken},
          method: 'POST'})
          .then(r => r.text())
          .then(html => Turbo.renderStreamMessage(html))
    }

    else {
      results.textContent = ""
    }
  }

}