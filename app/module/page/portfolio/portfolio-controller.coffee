Controller = require 'base/controller'
Project = require './project/project-controller'

module.exports = class PortfolioController extends Controller
	autoRender: true
	portfolio: null
	projects: null
	slides: null
	currentIndex: 0
	className: 'portfolio-carousel'
	template: require './templates/portfolio'

	attached: ->
		console.log 'PortfolioController Attached', @
		@portfolio = @options.portfolio
		@projects = @options.projects
		@currentIndex = @options.currentIndex if typeof @options.currentIndex is 'number'

		@$el.addClass 'i0'+@currentIndex

		@__appendProjectSlides()
		@resize()
		@__updateCounter()
		@__slideToIndex @currentIndex
		@__primeSlides()

	slideW: null
	resize: ->
		return undefined if !@portfolio or !@slides
		@slideW = @$el.outerWidth()
		
		wrapperW = @slideW * (@portfolio.projects.length)
		@$('.project-wrapper').css width: wrapperW

		@__resizeSlides()
	__resizeSlides: ->
		for slide, idx in @slides
			slideLeft = @slideW*idx
			slide.$el.css
				left: slideLeft
				width: @slideW

	__bindHandlers: ->
		# bind swipe handler (click and touch)
		# bind keyboard hotkeys (arrows)
	__primeSlides: ->
		setTimeout =>
			@$('.project-wrapper').addClass 'primed'
		, 250
	__slideToIndex: (index)->
		if typeof index isnt 'number'
			return false
		marginLeft = 0-(@slideW*index)
		@$('.project-wrapper').css 'margin-left': marginLeft

	__appendProjectSlides: ->
		@slides = []
		for project, idx in @portfolio.projects
			project.index = idx
			slide = new Project
				container: '.project-wrapper'
				modelOptions: project
			@slides.push slide
	__updateCounter: ->
		return if !@slides
		totalSlides = @__padDigits @slides.length
		currentSlide = @__padDigits @currentIndex+1
		$('.counter-current').html currentSlide
		$('.counter-total').html totalSlides

	__padDigits: (num)->
		padding = if num < 10 then '0' else ''
		padding+num