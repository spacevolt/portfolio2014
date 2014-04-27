Controller = require 'base/controller'
Project = require './project/project-controller'

swipe = require 'util/swipe'
ev = require 'util/events'

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
		@__bindHandlers()

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

	nextProject: ->
		return false if @currentIndex is @slides.length-1
		@__slideToIndex @currentIndex+1
	prevProject: ->
		return false if @currentIndex is 0
		@__slideToIndex @currentIndex-1
	__bindHandlers: ->
		$(document).on ev.all.keydown, @__keyPressed
		$(document).on ev.all.keyup, @__keyReleased
		$(window).on ev.all.transitionend, @__transitionEnd
		@$el.on ev.all.down, @__mouseDown
		@$el.on ev.all.up, @__mouseUp
		swipe.bind @$el.get(0), ->
			console.log 'foobar'
		# bind swipe handler (click and touch)
		# bind keyboard hotkeys (arrows)
	keylocked: false
	lockedkey: null
	__keyPressed: (e)=>
		validCodes = [37,39]
		code = e.keyCode
		return true if @keylocked  or @sliding or !(code in validCodes)

		@keylocked = true
		@lockedkey = code

		if code is 37
			@prevProject()
		if code is 39
			@nextProject()
	__keyReleased: (e)=>
		code = e.keyCode
		if code is @lockedkey
			@keylocked = false
		return true

	__mouseDown: =>
		@$el.addClass 'mousedown'
	__mouseUp: =>
		@$el.removeClass 'mousedown'

	sliding: false
	__primeSlides: ->
		setTimeout =>
			@$('.project-wrapper').addClass 'primed'
		, 250
	__slideToIndex: (index)->
		invalidIndex = typeof index isnt 'number'
		outOfRange = 0 > index and index > @slides.length
		return false if invalidIndex or outOfRange

		@currentIndex = index
		marginLeft = 0-(@slideW*index)
		@$('.project-wrapper').css 'margin-left': marginLeft
		@__updateCounter()
		@sliding = true if @$('.project-wrapper').hasClass 'primed'
	__transitionEnd: (e)=>
		targetClass = e.target.className
		@sliding = false if targetClass.indexOf 'project-wrapper' >= 0

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

	dispose: ->
		$(document).off ev.all.keydown
		$(document).off ev.all.keyup
		$(window).off ev.all.transitionend
		super