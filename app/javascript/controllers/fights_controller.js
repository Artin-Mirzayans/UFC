import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="fights"
export default class extends Controller {
  // DEFINES WHAT HTML TAGS WE NEED TO TARGET SO WE CAN READ/UPDATE/MODIFY THEM
  static targets = ["redMethodPredictionForm", "blueMethodPredictionForm", "distancePredictionForm"]

  // Initialize method, happens on load
  connect() {
    console.log("Fights Controller Connected")

  }

  red_method_submit() {
    this.redMethodPredictionFormTarget.requestSubmit()
    // Array.from(this.blueMethodPredictionFormTarget.children).forEach(item => item.checked = false)
    // Array.from(this.distancePredictionFormTarget.children).forEach(item => item.checked = false)

  }

  blue_method_submit() {
    this.blueMethodPredictionFormTarget.requestSubmit()
    // Array.from(this.redMethodPredictionFormTarget.children).forEach(item => item.checked = false)
    // Array.from(this.distancePredictionFormTarget.children).forEach(item => item.checked = false)
  }

  distance_submit() {
    this.distancePredictionFormTarget.requestSubmit()
    // Array.from(this.redMethodPredictionFormTarget.children).forEach(item => item.checked = false)
    // Array.from(this.blueMethodPredictionFormTarget.children).forEach(item => item.checked = false)
  }


  
}