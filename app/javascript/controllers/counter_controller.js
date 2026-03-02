import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { value: String }

  connect() {
    const target = parseInt(this.valueValue, 10)
    if (isNaN(target)) return

    const duration = 600
    const startTime = performance.now()
    const el = this.element

    const animate = (currentTime) => {
      const elapsed = currentTime - startTime
      const progress = Math.min(elapsed / duration, 1)
      // Ease-out cubic
      const eased = 1 - Math.pow(1 - progress, 3)
      const current = Math.round(eased * target)
      el.textContent = current.toLocaleString()

      if (progress < 1) {
        requestAnimationFrame(animate)
      }
    }

    el.textContent = "0"
    requestAnimationFrame(animate)
  }
}
