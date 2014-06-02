class Swipe
	namespace: 'swipeutil'
	debounceDuration: 150
	constructor: ->
		@__bindMouse = _.once @__bindMouseSwipe
		@__bindTouch = _.once @__bindTouchSwipe

	handlersSwipe: null
	bind: (direction, $el, handler, context)->
		validDirections = ["Left", "Right", "Up", "Down"]

		# direction parameter is optional, properly assign arguments
		if _.isElement(direction) or @__isJQuery(direction)
			[$el, handler, context] = [direction, $el, handler]
			direction = undefined
		else
			# Delegate to directional binders if direction parameter provided
			direction = @__capitalize direction.toLowerCase()
			if !(direction in validDirections)
				throw new Error "Swipe.bind : direction must be right, left, up, or down"
			method = 'swipe'+direction
			this[method]($el, handler, context)
			return true

		# No direction parameter passed in, assign handler to all swipes
		direction = "Swipe"
		@__registerHandlers direction, $el, handler, context

	handlersLeft: null
	swipeLeft: ($el, handler, context)->
		direction = "Left"
		@__registerHandlers direction, $el, handler, context
	handlersRight: null
	swipeRight: ($el, handler, context)->
		direction = "Right"
		@__registerHandlers direction, $el, handler, context
	handlersUp: null
	swipeUp: ($el, handler, context)->
		direction = "Up"
		@__registerHandlers direction, $el, handler, context
	handlersDown: null
	swipeDown: ($el, handler, context)->
		direction = "Down"
		@__registerHandlers direction, $el, handler, context

	__registerHandlers: (direction, $el, handler, context)->
		listPrefix = "handlers"
		listName = listPrefix+direction
		$el = @__validateParams $el, handler
		options = @__getOptions $el, handler, context

		@[listName] = @[listName] || []
		@[listName].push options
		
		@__bindMouse()
		@__bindTouch()
	__getOptions: ($el, handler, context)->
		handlerDefaults =
			$el: $(window)
			handler: null
			context: window
		options = {}
		options.$el = $el if $el
		options.handler = handler if handler
		options.context = context if context
		_.extend handlerDefaults, options

	# Mousey logic
	mouseBound: false
	__bindMouseSwipe: ->
		return false if @mouseBound is true
		@mouseBound = true
		$(window).on 'mousedown.'+@namespace, @__mouseDown
		$(window).on 'mouseup.'+@namespace, @__swipeUp
		$(window).on 'mousemove.'+@namespace, @__swipeMove
	# Touchy Logic
	touchBound: false
	__bindTouchSwipe: ->
		return false if @touchBound is true
		@touchBound = true
		$(window).on 'touchstart.'+@namespace, @__swipeStart
		$(window).on 'touchmove.'+@namespace, @__swipeMove
		$(window).on 'touchend.'+@namespace, @__swipeUp

	__handleSwipe: (target, directions)->
		for direction in directions
			@__executeHandlers target, 'Swipe' if direction
			@__executeHandlers target, direction if direction
	__executeHandlers: (target, direction)->
		handlers = this['handlers'+direction]
		return undefined if _.isNull(handlers) or _.isEmpty(handlers)
		for options in handlers
			targetClass = options.$el.get(0).className
			targetSelector = @__getSelector targetClass
			targetIsEl = $(target).hasClass targetClass
			targetIsParent = $(target).parents(targetSelector).length > 0
			options.handler.call options.context if targetIsEl or targetIsParent

	mouseIsDown: false
	swipeDirectionX: null
	swipeDirectionY: null
	swipeStartTime: null
	swipeStartCoords: null
	swipeLastCoords: null
	__swipeStart: (e)=>
		e = e.originalEvent.touches[0] if e.type is "touchstart"
		@swipeStartTime = new Date().getTime()
		@swipeStartCoords = [e.pageX, e.pageY]
	__mouseDown: (e)=>
		@__swipeStart e
		@mouseIsDown = true
	__swipeMove: (e)=>
		# Set direction flags
		if e.type is "touchmove"
			e = e.originalEvent.touches[0]
		else if @mouseIsDown is false
			return undefined

		currCoords = [e.pageX, e.pageY]
		startCoords = if @swipeLastCoords isnt null then @swipeLastCoords else @swipeStartCoords

		diffX = startCoords[0]-currCoords[0]
		diffY = startCoords[1]-currCoords[1]

		directionX = 'Left' if diffX > 0
		directionX = 'Right' if diffX < 0
		directionY = 'Up' if diffY > 0
		directionY = 'Down' if diffY < 0

		changedX = @swipeDirectionX and directionX and @swipeDirectionX isnt directionX
		changedY = @swipeDirectionY and directionY and @swipeDirectionY isnt directionY
		if changedX or changedY
			@swipeLastCoords = null
			@__swipeStart e
		else
			@swipeLastCoords = _.cloneDeep currCoords

		@swipeDirectionX = directionX
		@swipeDirectionY = directionY
	__swipeUp: (e)=>
		target = e.target
		e = e.originalEvent.touches[0] if e.type is "touchend"
		@mouseIsDown = false
		@swipeLastCoords = null
		directionX = @swipeDirectionX
		directionY = @swipeDirectionY
		@swipeDirectionX = null
		@swipeDirectionY = null

		swipeEndTime = new Date().getTime()
		swipeTime = swipeEndTime-@swipeStartTime
		return undefined if swipeTime < @debounceDuration

		@__handleSwipe target, [directionX, directionY]

	# Helpers
	__isJQuery: (el)->
		el instanceof jQuery
	__capitalize: (str)->
		str.charAt(0).toUpperCase() + str.slice(1)
	__getSelector: (str)->
		classes = str.split(' ')
		selectorStr = ''
		for selector in classes
			selectorStr = selectorStr+'.'+selector
		selectorStr

	__validateParams: ($el, handler)->
		if _.isElement $el
			$el = $($el)
		if not @__isJQuery $el
			throw new Error "Swipe.__validateParams: $el must be a dom element or jQuery object"
		if typeof handler isnt "function"
			throw new Error "Swipe.__validateParams: handler must be a function"
		$el

	unbindAll: ->
		$(window).off '.'+@namespace
		@mouseBound = false
		@touchBound = false
		@__clearLists()
		@constructor()
	__clearLists: ->
		@handlersUp = null
		@handlersDown = null
		@handlersRight = null
		@handlersLeft = null

window.carousel = window.carousel || {}
window.carousel.swipe = window.carousel.swipe || new Swipe
module.exports = window.carousel.swipe