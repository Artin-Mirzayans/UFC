import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="events"
export default class extends Controller {
  // DEFINES WHAT HTML TAGS WE NEED TO TARGET SO WE CAN READ/UPDATE/MODIFY THEM
  static targets = [ "searchInput", "searchForm", "results" ]

  // Initialize method, happens on load
  connect() {
    console.log("I am connected!!")
  }

  // STIMULUS CONTROLLER ACTION, CAN BE CALLED FROM THE FRONTEND VIA A FRONTEND EVENT
  search() {
    if (this.searchInputTarget.value.length > 0) {
      this.searchFormTarget.requestSubmit()
    } else {
      this.resultsTarget.textContent = ""
    }
  }
  
} // class