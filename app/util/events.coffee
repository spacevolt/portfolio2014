#Input strings
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
		transitionend     : 'transitionend msTransitionEnd webkitTransitionEnd'
		animationend      : 'animationend msAnimationEnd oanimationend webkitAnimationEnd'
		orientationchange : 'orientationchange'
	mouse:
		down 	: 'mousedown'
		move 	: 'mousemove'
		up		: 'mouseup'
		over	: 'mouseover'
		out		: 'mouseout'
		leave 	: 'mouseleave'
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
		transitionend: 'window:transitionend' # Fires when window fires transitionend event
		animationend: 'window:animationend' # Firew shen window fires animationend event

		assembler:
			carouselready: 'carousel:ready' # Fires when the assembler has instantiated the carousel

		data:
			ready: 'data:ready' # Fires when the data is ready

		view:
			appended: 'view:append' # Fires when a view has been appended to the DOM

		header:
			aboutlink: 'header:aboutlink' # Fires when the about link is clicked

module.exports = inputEvents