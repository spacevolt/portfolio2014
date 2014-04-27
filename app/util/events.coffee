#Input strings
transitionEvent = ->
	el = document.createElement('fakeelement')
	transitions =
		transition: 'transitionend'
		MSTransition: 'msTransitionEnd'
		MozTransition: 'transitionend'
		WebkitTransition: 'webkitTransitionEnd'
	for prop of transitions
		return transitions[prop] if el.style[prop] isnt undefined

inputEvents =
	# Mouse-and-Touch Events
	all:
		click   : 'click'
		blur    : 'blur'
		focus   : 'focus'
		resize  : 'resize'
		scroll  : 'scroll'
		down    : 'mousedown'
		up      : 'mouseup'
		keydown : 'keydown'
		keyup   : 'keyup'
		transitionend     : transitionEvent()
		orientationchange : 'orientationchange'
	# Media events
	media:
		videoend : 'ended'
		audioend : 'ended'
	mediator:
		# Events for Chaplin's mediator (pub/sub)
		resize : 'window:resize' # Fires when window level resize occurs
		orientation : 'window:orientation' # Fires when orientation change occurs
		blur : 'window:blur' # Fires when window loses focus
		focus : 'window:focus' # Fires when window gains focus

		assembler:
			carouselready: 'carousel:ready' # Fires when the assembler has instantiated the carousel

		data:
			ready: 'data:ready' # Fires when the data is ready

		view:
			appended: 'view:append' # Fires when a view has been appended to the DOM

module.exports = inputEvents