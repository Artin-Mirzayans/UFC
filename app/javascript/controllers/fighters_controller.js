import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="fighters"
export default class extends Controller {
  // DEFINES WHAT HTML TAGS WE NEED TO TARGET SO WE CAN READ/UPDATE/MODIFY THEM
  static targets = ["red_query", "blue_query", "red_results", "blue_results"]

  // Initialize method, happens on load
  connect() {
    console.log("Search Fighter Controller Connected")
  }

  // STIMULUS CONTROLLER ACTION, CAN BE CALLED FROM THE FRONTEND VIA A FRONTEND EVENT

  search_fighter(search_query, corner, results) {
    if(search_query.length > 0) {
      fetch(`fighter/${corner}/search/${search_query}`, {
          headers: { accept: "text/vnd.turbo-stream.html"},
          method: 'POST'})
          .then(r => r.text())
          .then(html => Turbo.renderStreamMessage(html))
    }

    else {
      results.textContent = ""
    } 
  }

  search_red() {
      this.search_fighter(this.red_queryTarget.value, "red", this.red_resultsTarget)
    }

  search_blue() {
      this.search_fighter(this.blue_queryTarget.value, "blue", this.blue_resultsTarget)
    }

  

  select(event) {
    event.preventDefault()
    if (event.path[1].id == 'search_results_red') {
      this.red_queryTarget.value = event.target.innerHTML
      this.red_resultsTarget.innerHTML = ""
    }

    else if (event.path[1].id == 'search_results_blue') {
      this.blue_queryTarget.value = event.target.innerHTML
      this.blue_resultsTarget.innerHTML = ""
    }

    else {
      console.log("Div Not Found")
    }
  }  



} // class