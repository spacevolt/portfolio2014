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

		$el.css 'margin-top': ''
		$el.css 'margin-top': top

module.exports = resizer