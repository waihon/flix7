import { Controller } from "@hotwired/stimulus"
import debounce from "debounce";

// Connects to data-controller="form"
export default class extends Controller {
  initialize() {
    // The way the debounce function works is you pass it a function
    // and it returns a debounced version of that function.
    // `bind(this)` is a fun little JavaScript thing.
    // The second argument is how long to wait in milliseconds, and
    // by default, that's 100 milliseconds.
    this.submit = debounce(this.submit.bind(this), 300)
  }

  // The event that triggered a Stimulus action is passed to the
  // action as the first argument.
  submit(event) {
    // Alternative: this.element.requestSubmit();
    event.target.form.requestSubmit();
  }
}
