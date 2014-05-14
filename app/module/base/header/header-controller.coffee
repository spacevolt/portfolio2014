Controller = require 'base/controller'

ev = require 'util/events'

module.exports = class HeaderController extends Controller
	autoRender: true
	className: 'hud'
	template: require './templates/header'

	attached: ->
		@__bindInputHandlers()

	aboutLinkClicked: =>
		@publishEvent ev.mediator.header.aboutlink

	__bindInputHandlers: ->
		@$('.about-link').on ev.all.click, @aboutLinkClicked