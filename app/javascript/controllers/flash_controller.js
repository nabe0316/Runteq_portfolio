import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "message" ]

  connect() {
    this.messageTarget.classList.add('translate-y-0', 'opacity-100')
    setTimeout(() => {
      this.close()
    }, 5000)
  }

  close() {
    this.messageTarget.classList.remove('translate-y-0', 'opacity-100')
    this.messageTarget.classList.add('-translate-y-full', 'opacity-0')
    setTimeout(() => {
      this.messageTarget.remove()
    }, 300)
  }
}