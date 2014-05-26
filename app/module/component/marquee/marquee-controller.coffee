Controller = require 'base/controller'
ItemController = require './item/item-controller'

ev = require 'util/events'

module.exports = class MarqueeController extends Controller
	autoRender: false
	className: 'marquee-container'
	template: require './templates/marquee'

	menuItems: null

	attached: ->
		@__bindInputs()
		@__bindEvents()
		@__instantiateItems()

	isOpen: false
	clickLocked: false
	toggleMenu: =>
		console.log 'toggleMenu', @isOpen, @clickLocked
		return undefined if @clickLocked
		if not @isOpen
			@openMenu()
		else
			@closeMenu()
	openMenu: =>
		console.log 'openMenu', @isOpen, @clickLocked
		if @scheduleMenuClose is true
			clearTimeout @menuCloseTimeout
			@scheduleMenuClose = false
		return undefined if @isOpen or @clickLocked
		@$el.addClass 'active'
		@clickLocked = true
		@isOpen = true
		return undefined
	closeMenu: =>
		console.log 'closeMenu', @isOpen, @clickLocked
		return undefined if !@isOpen or @clickLocked
		@$el.removeClass 'active'
		@clickLocked = true
		@isOpen = false
		return undefined

	__bindInputs: ->
		@$el.on ev.all.click, @toggleMenu
		@$el.on ev.mouse.over, @openMenu
		@$el.on ev.mouse.out, @__onMouseOut

	scheduleMenuClose: false
	menuCloseTimeout: null
	__onMouseOut: (e)=>
		console.log '__onMouseOut', @isOpen, @clickLocked
		@scheduleMenuClose = true
		@menuCloseTimeout = setTimeout =>
			@closeMenu()
		, 50

	__bindEvents: ->
		@subscribeEvent ev.mediator.transitionend, @__transitionEnded

	__transitionEnded: (e)->
		return false if not (e.target is @$el.get(0))
		@clickLocked = false

	__instantiateItems: ->
		@projects = @model.get 'projects'
		@menuItems = []
		defaults =
			container: @$('.marquee-wrapper').get(0)

		for project, idx in @projects
			model =
				model: project
			options = _.merge defaults, model
			@menuItems.push(new ItemController options)

		console.log 'MarqueeController: ', @menuItems