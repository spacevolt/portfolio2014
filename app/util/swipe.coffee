class Swipe
	debounceDuration: 150
	constructor: ->
		@__bindMouse = _.once @__bindMouseSwipe

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
		@[listName].push _.cloneDeep(options)
		
		@__bindMouseSwipe()
	__getOptions: ($el, handler, context)->
		handlerDefaults =
			$el: window
			handler: null
			context: window
		options = {}
		options.$el = $el
		options.handler = handler
		options.context = context if context
		_.merge handlerDefaults, options
		
	mouseBound: false
	__bindMouseSwipe: ->
		return false if @mouseBound is true
		@mouseBound = true
		$(window).on 'mousedown', @__mouseDown
		$(window).on 'mouseup', @__mouseUp
		$(window).on 'mousemove', @__mouseMove
	__handleMouseSwipe: (directions, distances)->
		for direction in directions
			@__executeHandlers 'Swipe' if direction
			@__executeHandlers direction if direction
	__executeHandlers: (direction)->
		handlers = this['handlers'+direction]
		return undefined if _.isNull(handlers) or _.isEmpty(handlers)
		for options in handlers
			options.handler.call options.context

	mouseIsDown: false
	mouseDirectionX: null
	mouseDirectionY: null
	mouseStartTime: null
	mouseStartCoords: null
	mouseDirectionChanged: false
	lastCoords: null
	__mouseStart: (e)->
		@mouseStartTime = new Date().getTime()
		@mouseStartCoords = [e.pageX, e.pageY]
	__mouseDown: (e)=>
		@__mouseStart e
		@mouseIsDown = true
	__mouseMove: (e)=>
		# Set direction flags
		return undefined if @mouseIsDown is false
		currCoords = [e.pageX, e.pageY]
		startCoords = if @lastCoords then @lastCoords else @mouseStartCoords

		diffX = startCoords[0]-currCoords[0]
		diffY = startCoords[1]-currCoords[1]

		directionX = 'Left' if diffX > 0
		directionX = 'Right' if diffX < 0
		directionY = 'Up' if diffY > 0
		directionY = 'Down' if diffY < 0

		changedX = @mouseDirectionX and directionX and @mouseDirectionX isnt directionX
		changedY = @mouseDirectionY and directionY and @mouseDirectionY isnt directionY
		if changedX or changedY
			@lastCoords = null
			@__mouseStart e
		else
			@lastCoords = _.cloneDeep currCoords

		@mouseDirectionX = directionX
		@mouseDirectionY = directionY
	__mouseUp: (e)=>
		@mouseIsDown = false
		@lastCoords = null
		directionX = @mouseDirectionX
		directionY = @mouseDirectionY
		@mouseDirectionX = null
		@mouseDirectionY = null

		mouseEndTime = new Date().getTime()
		mouseTime = mouseEndTime-@mouseStartTime
		return undefined if mouseTime < @debounceDuration

		distX = Math.abs(@mouseStartCoords[0]-e.pageX)
		distY = Math.abs(@mouseStartCoords[1]-e.pageY)

		@__handleMouseSwipe [directionX, directionY], [distX, distY]

	# Helpers
	__isJQuery: (el)->
		el instanceof jQuery
	__capitalize: (str)->
		str.charAt(0).toUpperCase() + str.slice(1)

	__validateParams: ($el, handler)->
		if _.isElement $el
			$el = $($el)
		if not @__isJQuery $el
			throw new Error "Swipe.__validateParams: $el must be a dom element or jQuery object"
		if typeof handler isnt "function"
			throw new Error "Swipe.__validateParams: handler must be a function"
		$el		

	unbindAll: ->
		# ...

window.PGomez = window.PGomez || {}
window.PGomez.swipe = window.PGomez.swipe || new Swipe
module.exports = window.PGomez.swipe