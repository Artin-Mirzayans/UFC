import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
  }

  remove() {
    this.element.remove()
  }
}