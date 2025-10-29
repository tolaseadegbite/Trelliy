import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="search-filter"
export default class extends Controller {
  // Define the target element for this controller
  static targets = ["filters"]

  // Action to be called on button click
  toggle() {
    // Toggles the 'hide' utility class on the filters target div
    this.filtersTarget.classList.toggle("hide")
  }

  /**
   * New method to handle clicks outside the component.
   * This is triggered by the `click@window` action.
   */
  closeOnClickOutside(event) {
    // Check three conditions:
    // 1. Was the click outside of this controller's element?
    // 2. Is the filter panel currently visible?
    const isOutside = !this.element.contains(event.target)
    const isVisible = !this.filtersTarget.classList.contains("hide")

    if (isOutside && isVisible) {
      // If both are true, hide the filters.
      this.filtersTarget.classList.add("hide")
    }
  }
}