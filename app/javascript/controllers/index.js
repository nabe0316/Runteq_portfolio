// Import and register all your controllers from the importmap under controllers/*

import { application } from "./application"
import { definitionsFromContext } from "stimulus/webpack-helpers"

import FlashController from "./flash_controller"
application.register("flash", FlashController)
// Eager load all controllers defined in the import map under controllers/**/*_controller
const context = require.context("controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
