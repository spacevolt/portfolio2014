# Layout modified to allow tansitions between pages
transition = require "util/transition"
ev = require 'util/events'

module.exports = class Layout extends Chaplin.Layout
	initialize: ->
		super
		@subscribeEvent 'beforeControllerDispose', @beforeDisposeHandler
		@subscribeEvent 'dispatcher:dispatch', @dispatchHandler
		@subscribeEvent 'PageTransitionEnd', @removeAllDisposedViews
		@subscribeEvent ev.mediator.assembler.carouselready, @setUpcomingEl

	removeAllDisposedViews: (views)->
		$('.garbage').each (index, el) ->
			$(el).remove()

	beforeDisposeHandler: (assembler)->
		if assembler.carousel
			@oldViewEl = assembler.carousel.el
	dispatchHandler: (assembler)->
		if assembler.carousel
			upcomingEl = assembler.carousel.el
		else return false

		if @oldViewEl
			options =
				current: @oldViewEl
				upcoming: upcomingEl
			transitionMethod = assembler.carousel.transition
			# flag the old view for collection
			$(@oldViewEl).addClass 'garbage'
			if _.isFunction transitionMethod
				fn = transitionMethod
			else if _.isString transitionMethod
				fn = transition[transitionMethod]
			if fn?
				fn options
		else
			$(upcomingEl).addClass 'current'

	setUpcomingEl: (assembler)->
		@oldViewEl = assembler.carousel.el
		upcomingEl = assembler.carousel.el
		$(upcomingEl).addClass 'current'