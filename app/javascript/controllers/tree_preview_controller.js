import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["svg"]

  connect() {
    console.log("Tree preview controller connected")
    this.updateColor(this.element.dataset.treePreviewInitialColor || 'green')
  }

  updateColor(event) {
    const color = event.target ? event.target.value : event
    const leafColor = this.getLeafColor(color)
    
    try {
      const svgElement = this.svgTarget.querySelector('svg')
      if (svgElement) {
        svgElement.querySelectorAll('.leaf, circle[fill]').forEach(element => {
          element.setAttribute('fill', leafColor)
        })
      } else {
        console.error("SVG element not found in the preview")
      }
    } catch (error) {
      console.error("Error updating tree color:", error)
    }
  }

  getLeafColor(colorName) {
    const colors = {
      green: '#228B22',
      pink: '#FFC0CB',
      orange: '#FFA500'
    }
    return colors[colorName] || colors.green
  }
}