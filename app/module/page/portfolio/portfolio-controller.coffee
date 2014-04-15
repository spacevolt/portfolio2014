Controller = require 'base/controller'
Project = require './project/project-controller'

module.exports = class PortfolioController extends Controller
	autoRender: true
	slides: null
	currentIndex: 0
	className: 'portfolio-carousel'
	template: require './templates/portfolio'

	attached: ->
		console.log 'PortfolioController Attached'
		@portfolio = @options.portfolio
		@projects = @options.projects
		@__appendProjectSlides()
		@resize()
		@__slideChanged()

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

	__appendProjectSlides: ->
		@slides = []
		for project, idx in @portfolio.projects
			project.index = idx
			slide = new Project
				container: '.project-wrapper'
				modelOptions: project
			@slides.push slide
	__slideChanged: ->
		return if !@slides
		totalSlides = @__padDigits @slides.length
		currentSlide = @__padDigits @currentIndex+1
		$('.counter-current').html currentSlide
		$('.counter-total').html totalSlides

	__padDigits: (num)->
		padding = if num < 10 then '0' else ''
		padding+num