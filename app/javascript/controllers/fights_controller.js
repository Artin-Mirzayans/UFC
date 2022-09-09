import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  connect() {
    console.log("Fights Controller Connected")
  }

  method_submit(event) {
    let event_id = event.target.dataset.event
    let fight_id = event.target.dataset.fight
    let fighter_id = event.target.dataset.fighter
    let method = event.target.dataset.method

    fetch(`${event_id}/fights/${fight_id}/fighter/${fighter_id}/method/${method}`, {
      headers: { accept: "text/vnd.turbo-stream.html"},
      method: 'POST'})
      .then(r => r.text())
      .then(html => Turbo.renderStreamMessage(html))
  }

  distance_submit(event) {
    let event_id = event.target.dataset.event
    let fight_id = event.target.dataset.fight
    let method = event.target.dataset.method
    fetch(`${event_id}/fights/${fight_id}/method/${method}`, {
      headers: { accept: "text/vnd.turbo-stream.html"},
      method: 'POST'})
      .then(r => r.text())
      .then(html => Turbo.renderStreamMessage(html))
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

}