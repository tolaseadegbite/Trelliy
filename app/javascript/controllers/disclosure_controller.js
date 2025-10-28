import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="disclosure"
export default class extends Controller {
  static targets = ["content"]

  connect() {
    // If any search parameters are active, open the details block by default.
    const urlParams = new URLSearchParams(window.location.search);
    if (urlParams.has('q')) {
      this.contentTarget.open = true
    }
  }

  toggle() {
    // Toggle the 'open' attribute of the <details> element.
    this.contentTarget.open = !this.contentTarget.open
  }
}