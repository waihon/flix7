// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
//import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
// For Stimulus, you must import controllers in your JavaScript entrypoint file.
import "../controllers"
import { Turbo } from "@hotwired/turbo-rails"

Rails.start()
//Turbolinks.start()
ActiveStorage.start()
Turbo.session.drive = true
Turbo.setProgressBarDelay(100)  // Default is 500 ms
