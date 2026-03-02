import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.style.transition = "opacity 0.3s ease, transform 0.3s ease"
    this.element.style.transform = "translateY(-8px)"
    this.element.style.opacity = "0"

    requestAnimationFrame(() => {
      this.element.style.transform = "translateY(0)"
      this.element.style.opacity = "1"
    })

    this.timeout = setTimeout(() => this.dismiss(), 5000)
    this.element.addEventListener("click", () => this.dismiss())
  }

  disconnect() {
    if (this.timeout) clearTimeout(this.timeout)
  }

  dismiss() {
    if (this.timeout) clearTimeout(this.timeout)
    this.element.style.opacity = "0"
    this.element.style.transform = "translateY(-8px)"
    setTimeout(() => this.element.remove(), 300)
  }
}
