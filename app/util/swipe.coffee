class Swipe
	handlerDefaults:
		id: null
		el: window
		handler: null
		context: window

	swipeHandlers: null
	bind: (direction, $el, handler, context)->
		validDirections = ["Left", "Right", "Up", "Down"]

		if _.isElement(direction) or @__isJQuery(direction)
			[$el, handler, context] = [direction, $el, handler]
			direction = undefined
		else
			direction = @__capitalize direction.toLowerCase()
			if !(direction in validDirections)
				throw new Error "Swipe.bind : direction must be right, left, up, or down"
			method = 'swipe'+direction
			this[method]($el, handler, context)
			return true

		$el = @__validateParams $el, handler
		console.log direction, $el, handler, context

	leftHandlers: null
	swipeLeft: ($el, handler, context)->
		$el = @__validateParams $el, handler
	rightHandlers: null
	swipeRight: ($el, handler, context)->
		$el = @__validateParams $el, handler
	upHandlers: null
	swipeUp: ($el, handler, context)->
		$el = @__validateParams $el, handler
	downHandlers: null
	swipeDown: ($el, handler, context)->
		$el = @__validateParams $el, handler

	__bindMouseSwipe: ->
		# ...
	__handleSwipe: ->
		# ...

	downCoords: null
	upCoords: null
	__mouseDownHandler: ->
		# ...
	__mouseMoveHandler: ->
		# ...
	__mouseUpHandler: ->
		# ...

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

	dispose: ->
		# ...

module.exports = new Swipe