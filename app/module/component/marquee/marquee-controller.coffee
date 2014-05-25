Controller = require 'base/controller'

ev = require 'util/events'

module.exports = class MarqueeController extends Controller
	autoRender: false
	className: 'marquee-container'
	template: require './templates/marquee'

	attached: ->
		@__bindInputs()
		@__bindEvents()

		# @projects = @model.get 'projects'
		# console.log 'MarqueeController: ', @projects

	isOpen: false
	clickLocked: false
	toggleMenu: =>
		return undefined if @clickLocked
		if not @isOpen
			@openMenu()
		else
			@closeMenu()
	openMenu: =>
		return undefined if @isOpen or @clickLocked
		@$el.addClass 'active'
		@clickLocked = true
		@isOpen = true
	closeMenu: =>
		return undefined if !@isOpen or @clickLocked
		@$el.removeClass 'active'
		@clickLocked = true
		@isOpen = false

	__bindInputs: ->
		@$el.on ev.all.click, @toggleMenu
		@$el.on ev.mouse.over, @openMenu
		@$el.on ev.mouse.out, @closeMenu

	__bindEvents: ->
		@subscribeEvent ev.mediator.transitionend, @__transitionEnded

	__transitionEnded: (e)->
		return false if not (e.target is @$el.get(0))
		@clickLocked = false