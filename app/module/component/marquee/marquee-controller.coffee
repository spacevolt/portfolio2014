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
		@resize()

	resize: ->
		@__resizeMenuItems()
	__resizeMenuItems: ->
		return undefined if @menuItems is null

		large = 1000
		medium = 345
		menuH = @$el.outerHeight()

		numItems = 8
		numItems = 5 if menuH < large
		numItems = 2 if menuH < medium

		itemH = menuH/numItems

		for item in @menuItems
			item.setHeight itemH

	isOpen: false
	clickLocked: false
	toggleMenu: =>
		# console.log 'toggleMenu', @isOpen, @clickLocked
		return undefined if @clickLocked
		if not @isOpen
			@openMenu()
		else
			@closeMenu()
	openMenu: =>
		# console.log 'openMenu', @isOpen, @clickLocked
		if @scheduleMenuClose is true
			clearTimeout @menuCloseTimeout
			@scheduleMenuClose = false
		return undefined if @isOpen or @clickLocked
		@$el.addClass 'active'
		@clickLocked = true
		@isOpen = true
		return undefined
	closeMenu: =>
		# console.log 'closeMenu', @isOpen, @clickLocked
		return undefined if !@isOpen or @clickLocked
		@$el.removeClass 'active'
		@clickLocked = true
		@isOpen = false
		return undefined

	__bindInputs: ->
		@$el.on ev.all.click, @toggleMenu
		@$el.on ev.mouse.over, @openMenu
		@$el.on ev.mouse.leave, @__onMouseLeave

	scheduleMenuClose: false
	menuCloseTimeout: null
	__onMouseLeave: (e)=>
		# console.log '__onMouseLeave', @isOpen, @clickLocked
		@scheduleMenuClose = true
		@menuCloseTimeout = setTimeout =>
			@closeMenu()
		, 50

	__bindEvents: ->
		@subscribeEvent ev.mediator.transitionend, @__transitionEnded

	__transitionEnded: (e)->
		return false if not (e.target is @$el.get(0))
		# console.log '__transitionEnded', e.target
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

	dispose: ->
		# Workaround for a bug in Chaplin composer:
		# this controller is being disposed despite
		# being reused on every page. Deny disposal.
		return undefined