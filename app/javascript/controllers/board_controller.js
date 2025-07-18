import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="board"
export default class extends Controller {
  static values = {
    roomId: Number,
    whiteboardId: Number
  };
  static targets = ["board"];

  connect() {
    this.timeout = null;
  }

  save() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      const body = this.boardTarget.innerHTML;
      const url = this.whiteboardIdValue
        ? `/rooms/${this.roomIdValue}/whiteboards/${this.whiteboardIdValue}`
        : `/rooms/${this.roomIdValue}/whiteboards`;

      const method = this.whiteboardIdValue ? "PATCH" : "POST";

      fetch(url, {
        method: method,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        },
        body: JSON.stringify({ whiteboard: { body: body } }),
      })
        .then((response) => {
          if (!response.ok) throw new Error("保存失敗");
          if (!this.whiteboardIdValue && method === "POST") {
            return response.json();
          }
        })
        .then((data) => {
          if (data && data.id) {
            this.whiteboardIdValue = data.id;
          }
        })
        .catch((error) => {
          console.error(error);
        });
    }, 1000);
  }
}

