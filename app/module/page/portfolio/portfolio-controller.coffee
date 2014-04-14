Controller = require 'base/controller'
Project = require './project/project-controller'

module.exports = class PortfolioController extends Controller
	autoRender: true
	slides: null
	className: 'portfolio-carousel'
	template: require './templates/portfolio'

	attached: ->
		console.log 'PortfolioController Attached'
		@portfolio = @options.portfolio
		@projects = @options.projects
		@__appendProjectSlides()
		@resize()

	slideW: null
	slideH: null
	resize: ->
		return undefined if !@portfolio or !@slides
		@slideW = @$('.portfolio-carousel').outerWidth()
		@slideH = @$('.portfolio-carousel').outerHeight()
		
		wrapperW = @slideW * (@portfolio.projects.length)
		@$('.project-wrapper').css width: wrapperW

		slideLeft = @slideW*idx
		slideTop = @slideH*0.08
		console.log slideTop
		for slide, idx in @slides
			slide.$el.css
				left: slideLeft
				width: @slideW
			slide.$('.project-feature').css
				'padding-top': slideTop
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