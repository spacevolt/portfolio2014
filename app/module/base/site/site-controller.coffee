Controller = require 'base/controller'

ev = require 'util/events'

module.exports = class SiteController extends Controller
	autoRender: true
	container: 'body'
	id: 'Site-Container'
	regions:
		header: 'nav.header'
		main: '#Page-Container .page-wrapper'
	template: require './templates/site'

	attached: ->
		@__bindPageBlocker()

	resize: ->
		winH = $(window).height()
		@$el.css 'height', winH

	__bindPageBlocker: ->
		@$('.page-blocker').on ev.all.click, @__pageBlockerClicked
		@subscribeEvent ev.mediator.menu.open, @__openPageBlocker
		@subscribeEvent ev.mediator.menu.close, @__closePageBlocker
	__pageBlockerClicked: =>
		@publishEvent ev.mediator.pageblocker.clicked
	__openPageBlocker: ->
		@$('.page-blocker').addClass 'active'
	__closePageBlocker: ->
		@$('.page-blocker').removeClass 'active'