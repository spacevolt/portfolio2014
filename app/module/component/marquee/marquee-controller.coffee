Controller = require 'base/controller'

ev = require 'util/events'

module.exports = class MarqueeController extends Controller
	autoRender: false
	className: 'marquee-container'
	template: require './templates/marquee'

	attached: ->
		@__bindInputs()

		# @projects = @model.get 'projects'
		# console.log 'MarqueeController: ', @projects

	isOpen: false
	toggleMenu: =>
		if not @isOpen
			@openMenu()
		else
			@closeMenu()
	openMenu: =>
		@$el.addClass 'active'
		@isOpen = true
	closeMenu: =>
		@$el.removeClass 'active'
		@isOpen = false

	__bindInputs: ->
		@$el.on ev.all.click, @toggleMenu
		@$el.on ev.mouse.over, @openMenu
		@$el.on ev.mouse.out, @closeMenu