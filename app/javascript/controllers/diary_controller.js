import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="diary"
export default class extends Controller {
  static values = {
    roomId: Number,
    diaryId: Number
  };
  static targets = ["diary"];

  connect() {
    this.timeout = null;
  }

  save() {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      const body = this.diaryTarget.innerHTML;
      const url = this.diaryIdValue
        ? `/rooms/${this.roomIdValue}/exchange_diaries/${this.diaryIdValue}`
        : `/rooms/${this.roomIdValue}/exchange_diaries`;

      const method = this.diaryIdValue ? "PATCH" : "POST";

      fetch(url, {
        method: method,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        },
        body: JSON.stringify({ exchange_diary: { body: body } }),
      })
        .then((response) => {
          if (!response.ok) throw new Error("保存失敗");
          if (!this.diaryIdValue && method === "POST") {
            return response.json();
          }
        })
        .then((data) => {
          if (data && data.id) {
            this.diaryIdValue = data.id;
          }
        })
        .catch((error) => {
          console.error(error);
        });
    }, 1000);
  }
}
