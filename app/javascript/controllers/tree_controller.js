import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["leaf"]

  connect() {
    console.log("Tree controller connected")
  }

  navigate(event) {
    event.preventDefault()
    const messageId = event.currentTarget.dataset.messageId
    window.location.href = `/messages/${messageId}`
  }
}