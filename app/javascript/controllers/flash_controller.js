import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.style.transition = "transform 0.3s ease-in-out, opacity 0.3s ease-in-out"
    this.element.style.transform = "translateY(0)"
    this.element.style.opacity = "1"

    // 5秒後に自動的に閉じる
    this.timeout = setTimeout(() => {
      this.close()
    }, 5000)
  }

  close() {
    clearTimeout(this.timeout)
    this.element.style.transform = "translateY(-100%)"
    this.element.style.opacity = "0"
    
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}