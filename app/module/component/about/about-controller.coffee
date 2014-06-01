Controller = require 'base/controller'

ev = require 'util/events'

module.exports = class AboutController extends Controller
	autoRender: true
	className: 'about-page'
	template: require './templates/about'

	attached: ->
		@__bindHandlers()

	__bindHandlers: ->
		@$('.close-button').on ev.all.click, @__closeButtonClicked

	__closeButtonClicked: =>
		@publishEvent ev.mediator.header.aboutlink