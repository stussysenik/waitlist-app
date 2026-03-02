import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["source"]

  copy() {
    navigator.clipboard.writeText(this.sourceTarget.value || this.sourceTarget.textContent)
    const button = this.element.querySelector("[data-action*='clipboard#copy']")
    if (button) {
      const original = button.textContent
      button.textContent = "Copied!"
      setTimeout(() => { button.textContent = original }, 2000)
    }
  }
}
