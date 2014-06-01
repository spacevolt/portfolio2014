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

	menuPrimed: false
	primeTimeout: undefined
	resize: ->
		@__unprimeMenu()

		fitAll = if @isOpen then false else true
		@__resizeMenuItems fitAll

		@__primeMenu()
	__unprimeMenu: ->
		clearTimeout @primeTimeout
		noMenuItems = @menuItems is null
		notPrimed = @menuPrimed is false
		return undefined if noMenuItems or notPrimed

		@$el.removeClass 'primed'
		@menuPrimed = false
	__primeMenu: ->
		noMenuItems = @menuItems is null
		alreadyPrimed = @menuPrimed is true
		return undefined if noMenuItems or alreadyPrimed

		@primeTimeout = setTimeout =>
			@$el.addClass 'primed'
			@menuPrimed = true
		, 500
	__resizeMenuItems: (fitAll)->
		return undefined if @menuItems is null

		medium = 600
		menuH = @$el.outerHeight()

		numItems = 6 if menuH > medium
		numItems = 4 if menuH < medium
		numItems = @menuItems.length if fitAll is true

		itemH = menuH/numItems

		for item in @menuItems
			item.setHeight itemH

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
		if @scheduleMenuClose is true
			clearTimeout @menuCloseTimeout
			@scheduleMenuClose = false
		return undefined if @isOpen or @clickLocked
		console.log 'openMenu', @isOpen, @clickLocked
		@clickLocked = true
		@__resizeMenuItems false
		setTimeout =>
			@$el.addClass 'active'
			@isOpen = true
		, 400
		return undefined
	closeMenu: =>
		clearTimeout @menuCloseTimeout
		@scheduleMenuClose = false
		return undefined if !@isOpen or @clickLocked
		console.log 'closeMenu', @isOpen, @clickLocked
		@$el.removeClass 'active'
		@clickLocked = true
		setTimeout =>
			@__resizeMenuItems true
			setTimeout =>
				@isOpen = false
			, 400
		, 400
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
		console.log '__transitionEnded', e.target
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