import { Controller } from "@hotwired/stimulus"
import { DirectUpload } from "@rails/activestorage";

let target = "";
let progress = "";
let progress_str = ""


export default class extends Controller {

  static targets = ["input_red", "input_blue", "progress_red", "progress_blue"];

  uploadFile(event) {
    if (event.target.id.includes("red")) {
      target = this.input_redTarget;
      progress = this.progress_redTarget
      progress_str = "progress_red"
    }
    else if (event.target.id.includes("blue")) {
      target = this.input_blueTarget;
      progress = this.progress_blueTarget
      progress_str = "progress_blue"
    }

    Array.from(target.files).forEach((file) => {
      const upload = new DirectUpload(
        file,
        target.dataset.directUploadUrl,
        this // callback directUploadWillStoreFileWithXHR(request)
      );
      upload.create((error, blob) => {
        if (error) {
          console.log(error);
        } else {
          this.createHiddenBlobInput(blob);
          // if you're not submitting a form after upload. you need to attach
          // uploaded blob to some model here and skip hidden input.
        }
      });
    });
  }

  // add blob id to be submitted with the form
  createHiddenBlobInput(blob) {
    const hiddenField = document.createElement("input");
    hiddenField.setAttribute("type", "hidden");
    hiddenField.setAttribute("value", blob.signed_id);
    hiddenField.name = target.name;
    this.element.appendChild(hiddenField);
  }

  directUploadWillStoreFileWithXHR(request) {
    request.upload.addEventListener("progress", (event) => {
      this.progressUpdate(event);
    });
  }

  progressUpdate(event) {
    const load = (event.loaded / event.total) * 100;
    progress.innerHTML = load;

    // if you navigate away from the form, progress can still be displayed 
    // with something like this:
    // document.querySelector("#global-progress").innerHTML = progress;
  }

}