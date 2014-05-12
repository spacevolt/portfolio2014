resizer =
	__getjQueryWrapper: (el)->
		$el = if el instanceof jQuery then el else $(el)

	fitToContainer: (el, container)->
		$el = @__getjQueryWrapper el
		$container = @__getjQueryWrapper container

		$el.css width: '', height: '', 'margin-top': ''
		eW = $el.outerWidth()
		eH = $el.outerHeight()
		eR = eW/eH
		cW = $container.outerWidth()
		cH = $container.outerHeight()
		cR = cW/cH

		scaleToWidth = eR > cR
		if scaleToWidth
			$el.css width: cW
			@centerVertically $el, $container
		else
			$el.css height: cH

	centerVertically: (el, container)->
		$el = @__getjQueryWrapper el
		$container = @__getjQueryWrapper container

		eH = $el.outerHeight()
		cH = $container.outerHeight()
		top = (cH-eH)/2

		$el.css {'margin-top': '', 'margin-left': ''}
		$el.css 'margin-top': top
	centerHorizontally: (el, container)->
		$el = @__getjQueryWrapper el
		$container = @__getjQueryWrapper container

		eW = $el.outerWidth()
		cW = $container.outerWidth()
		left = (cW-eW)/2

		$el.css {'margin-top': '', 'margin-left': ''}
		$el.css 'margin-left', left

	coverImage: (el, container)->
		$el = @__getjQueryWrapper el
		$container = @__getjQueryWrapper container

		$el.css {width: '', height: ''}
		cRatio = $container.outerWidth()/$container.outerHeight()
		eRatio = $el.outerWidth()/$el.outerHeight()

		console.log 'coverImage ratio', eRatio
		@__fillWidth($el, $container) if cRatio > eRatio
		@__fillHeight($el, $container) if cRatio <= eRatio

	__fillWidth: ($el, $container)->
		cW = $container.outerWidth()
		eRatio = $el.outerWidth()/$el.outerHeight()
		eH = cW/eRatio

		$el.css {width: '', height: ''}
		$el.css {width: cW, height: eH}

		@centerVertically $el, $container
	__fillHeight: ($el, $container)->
		cH = $container.outerHeight()
		eRatio = $el.outerWidth()/$el.outerHeight()
		eW = eRatio*cH
		console.log '__fillHeight ratio', eRatio
		$el.css {width: '', height: ''}
		$el.css {width: eW, height: cH}

		@centerHorizontally $el, $container

module.exports = resizer