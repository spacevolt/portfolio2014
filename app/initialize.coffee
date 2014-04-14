Application = require 'application'
routes = require 'routes'

# Remove Sizzle's cache (memory management)
$.expr.cacheLength = 1

# Initialize the application on DOM ready event.
$ ->
	new Application {
		title: 'Priscilla Gomez',
		controllerSuffix: '-assembler',
		controllerPath: 'assemblers/',
		routes,
		pushState: false,
		openExternalToBlank: true
	}