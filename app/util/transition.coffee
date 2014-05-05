transition =
	slide: (options)->
		current = options.current
		upcoming = options.upcoming

		setTimeout ->
			$(current).removeClass('current').addClass('prev')
			$(upcoming).addClass 'current'
			setTimeout ->
				Chaplin.mediator.publish 'PageTransitionEnd', {previous: current, current: upcoming}
			, 1050
		, 200

	none: (options)->
		#

module.exports = transition