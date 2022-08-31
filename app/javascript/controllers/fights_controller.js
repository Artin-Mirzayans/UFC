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

  }

  blue_method_submit() {
    this.blueMethodPredictionFormTarget.requestSubmit()
  }

  distance_submit() {
    this.distancePredictionFormTarget.requestSubmit()
  }

  prompt(event) {
    let event_id = event.target.dataset.event
    let fight_id = event.target.dataset.fight
    let current_wager = event.target.dataset.wager

    let wager = prompt("Enter your wager", current_wager)
    if (wager != null) {
      fetch(`${event_id}/fights/${fight_id}/${wager}`, {
        headers: { accept: "text/vnd.turbo-stream.html"},
        method: 'PATCH'})
        .then(r => r.text())
        .then(html => Turbo.renderStreamMessage(html))
    }
  }

  // form_disable() {
  //   console.log("Hello YOU SEE ME!")
  //   // Array.from(this.redMethodPredictionFormTarget.children).forEach(item => item.disabled = true)
  //   // Array.from(this.distanceMethodPredictionFormTarget.children).forEach(item => item.disabled = true)
  //   // Array.from(this.redMethodPredictionFormTarget.children).forEach(item => item.disabled = true)
  // }


  
}