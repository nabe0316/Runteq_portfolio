import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["info"]

  connect() {
    console.log("LeafHoverController connected")
    this.element.addEventListener("mouseenter", () => this.showInfo())
    this.element.addEventListener("mouseleave", () => this.hideInfo())
  }

  showInfo() {
    console.log("Showing info")
    if (this.hasInfoTarget) {
      this.infoTarget.style.display = "block"
    }
  }

  hideInfo() {
    console.log("Hiding info")
    if (this.hasInfoTarget) {
      this.infoTarget.style.display = "none"
    }
  }
}