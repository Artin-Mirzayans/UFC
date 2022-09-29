import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    liveodds: String,
    wageredodds: String
  }

  connect() {}

  mouseOver(event) {
    if (event.target.classList.contains('selected')) {
      event.target.querySelector(".odds").innerHTML = this.liveoddsValue
    }
  }

  mouseOut(event) {
    if (event.target.classList.contains('selected')) {
      event.target.querySelector(".odds").innerHTML = this.wageredoddsValue
    }
  }

  method_submit(event) {
    let event_id = event.target.dataset.event
    let fight_id = event.target.dataset.fight
    let fighter_id = event.target.dataset.fighter
    let method = event.target.dataset.method

    if (event.target.className != "wager") {
      const csrfToken = document.querySelector("[name='csrf-token']").content
      fetch(`${event_id}/fights/${fight_id}/fighter/${fighter_id}/method/${method}`, {
        headers: { accept: "text/vnd.turbo-stream.html", "X-CSRF-Token": csrfToken},
        method: 'POST'})
        .then(r => r.text())
        .then(html => Turbo.renderStreamMessage(html))
      }
  }
  

  distance_submit(event) {
    let event_id = event.target.dataset.event
    let fight_id = event.target.dataset.fight
    let method = event.target.dataset.method

    if (event.target.className != "wager") {
      const csrfToken = document.querySelector("[name='csrf-token']").content
      fetch(`${event_id}/fights/${fight_id}/method/${method}`, {
        headers: { accept: "text/vnd.turbo-stream.html", "X-CSRF-Token": csrfToken},
        method: 'POST'})
        .then(r => r.text())
        .then(html => Turbo.renderStreamMessage(html))
      } 

  }

  prompt(event) {
    let event_id = event.target.dataset.event
    let fight_id = event.target.dataset.fight
    let current_wager = event.target.dataset.wager

    if (!event.target.parentElement.parentElement.parentElement.classList.contains('disabled')) {
  
      let wager = prompt("Enter your wager", current_wager)
      if (wager != null) {
        const csrfToken = document.querySelector("[name='csrf-token']").content
        fetch(`${event_id}/fights/${fight_id}/${wager}`, {
          headers: { accept: "text/vnd.turbo-stream.html", "X-CSRF-Token": csrfToken},
          method: 'PATCH'})
          .then(r => r.text())
          .then(html => Turbo.renderStreamMessage(html))
      }
    }

  }

}