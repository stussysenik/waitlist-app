import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mobile", "backdrop"]

  open() {
    this.mobileTarget.classList.remove("-translate-x-full")
    this.mobileTarget.classList.add("translate-x-0")
    this.backdropTarget.classList.remove("hidden")
  }

  close() {
    this.mobileTarget.classList.add("-translate-x-full")
    this.mobileTarget.classList.remove("translate-x-0")
    this.backdropTarget.classList.add("hidden")
  }
}
