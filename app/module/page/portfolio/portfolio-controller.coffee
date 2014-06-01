Controller = require 'base/controller'
Project = require './project/project-controller'
About = require 'module/component/about/about-controller'

swipe = require 'util/swipe'
ev = require 'util/events'
device = require 'util/device'

module.exports = class PortfolioController extends Controller
	autoRender: true
	portfolio: null
	projects: null
	slides: null
	currentIndex: 0
	slideClass:
		prev: 'prev'
		curr: 'curr'
		next: 'next'
	className: 'portfolio-carousel'
	template: require './templates/portfolio'

	attached: ->
		@__appendAboutPage()
		@__appendProjectSlides()
		@__slideToIndex @currentIndex
		@__primeSlides()
		@__bindHandlers()

	onAboutPage: false
	aboutLinkClicked: ->
		if @onAboutPage
			@slideOutAbout()
		else
			@slideInAbout()
	slideInAbout: ->
		@$el.addClass('about')
		@onAboutPage = true
		@clickLocked = true
	slideOutAbout: ->
		@$el.removeClass('about')
		@onAboutPage = false
		@clickLocked = true

	nextProject: ->
		if @currentIndex is @slides.length-1
			@lastSlide()
			return false

		@__slideToIndex @currentIndex+1
	prevProject: ->
		if @currentIndex is 0
			@firstSlide()
			return false

		@__slideToIndex @currentIndex-1
	firstSlide: ->
		@slides[@currentIndex].$el.addClass 'first-slide'
		@clickLocked = true
	lastSlide: ->
		@slides[@currentIndex].$el.addClass 'last-slide'
		@clickLocked = true
	__updateSlug: ->
		return false if not @slides and not device.supports 'history'
		slug = '#!/'+@slides[@currentIndex].model.get 'slug'
		return false if slug is location.hash

		history.replaceState null, null, slug

	__bindHandlers: ->
		@__bindKeyboard()
		@__bindCursor()
		@__bindSwipe()
		# unlock transition events
		@subscribeEvent ev.mediator.transitionend, @__transitionEnded
		@subscribeEvent ev.mediator.animationend, @__transitionEnded
		# toggle about page
		@subscribeEvent ev.mediator.header.aboutlink, @aboutLinkClicked
	__bindSwipe: ->
		swipeRight = _.bind @prevProject, @
		swipeLeft = _.bind @nextProject, @
		swipe.swipeLeft @$el, swipeLeft
		swipe.swipeRight @$el, swipeRight
	__bindKeyboard: ->
		$(document).on ev.all.keydown, @__keyPressed
		$(document).on ev.all.keyup, @__keyReleased
	__bindCursor: ->
		@$el.on ev.all.down, @__mouseDown
		@$el.on ev.all.up, @__mouseUp

	keylocked: false
	lockedkey: null
	__keyPressed: (e)=>
		validCodes = [37,39]
		code = e.keyCode
		return true if @keylocked  or @clickLocked or !(code in validCodes)

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

	clickLocked: false
	__primeSlides: ->
		setTimeout =>
			@$('.project-wrapper').addClass 'primed'
		, 250
	__slideToIndex: (index)->
		invalidIndex = typeof index isnt 'number'
		outOfRange = 0 > index and index > @slides.length
		isCurrentSlide = index is @currentIndex
		return false if invalidIndex or outOfRange or isCurrentSlide

		slideFn = @__slideToPrev
		slideFn = @__slideToNext if index > @currentIndex
		recurseCount = Math.abs(@currentIndex-index)

		slideFn(recurseCount)

		@clickLocked = true if @$('.project-wrapper').hasClass 'primed'
	__slideToPrev: (recurseCount)=>
		currIdx = @currentIndex
		allPositions = @slideClass.prev+' '+@slideClass.curr+' '+@slideClass.next

		@slides[currIdx].$el.removeClass allPositions
		@slides[currIdx].$el.addClass @slideClass.next

		@slides[currIdx-1].$el.removeClass allPositions
		@slides[currIdx-1].$el.addClass @slideClass.curr
		@slides[currIdx-1].resize()

		@currentIndex--

		recurseCount-- if recurseCount
		if recurseCount
			$(window).one ev.all.transitionend, =>
				@__slideToPrev(recurseCount)
	__slideToNext: (recurseCount)=>
		currIdx = @currentIndex
		allPositions = @slideClass.prev+' '+@slideClass.curr+' '+@slideClass.next

		@slides[currIdx].$el.removeClass allPositions
		@slides[currIdx].$el.addClass @slideClass.prev

		@slides[currIdx+1].$el.removeClass allPositions
		@slides[currIdx+1].$el.addClass @slideClass.curr
		@slides[currIdx+1].resize()

		@currentIndex++

		recurseCount-- if recurseCount
		if recurseCount
			$(window).one ev.all.transitionend, =>
				@__slideToNext(recurseCount)

	__transitionEnded: (e)=>
		targetClass = e.target.className
		targetIsSlide = targetClass.indexOf('project-slide') >= 0
		targetIsCarousel = targetClass.indexOf('portfolio-carousel') >= 0

		@__slideTransitionEnd() if targetIsSlide
		@__carouselTransitionEnd() if targetIsCarousel
		# return false if targetClass.indexOf('project-slide') >= 0
	__slideTransitionEnd: ->
		@clickLocked = false
		@slides[@currentIndex].$el.removeClass 'first-slide last-slide'
		@__updateSlug()
	__carouselTransitionEnd: ->
		@clickLocked = false
		if not @onAboutPage
			@$('.about-wrapper').css 'display', ''

	__appendAboutPage: ->
		options = _.merge { container: @$('.about-wrapper') }, @portfolio.about
		@aboutPage = new About options
	__appendProjectSlides: ->
		@slides = []
		for project, idx in @portfolio.projects
			project.index = idx
			slide = new Project
				container: @$('.project-wrapper')
				modelOptions: project
			@slides.push slide
		@__prepareSlideClasses()
	__prepareSlideClasses: ->
		index = @currentIndex
		positionClass = @slideClass.prev
		
		for slide, idx in @slides
			positionClass = @slideClass.curr if index is idx
			positionClass = @slideClass.next if index < idx
			slide.$el.addClass positionClass

	__padDigits: (num)->
		padding = if num < 10 then '0' else ''
		padding+num

	dispose: ->
		$(document).off ev.all.keydown
		$(document).off ev.all.keyup
		super