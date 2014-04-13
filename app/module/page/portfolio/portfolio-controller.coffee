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
		@resize()
		@__appendProjectSlides()

	slideW: null
	slideH: null
	resize: ->
		@slideW = @$('.project-wrapper').outerWidth()
		@slideH = @$('.project-wrapper').outerHeight()
		# resize carousel striper
		# resize project containers
		# reposition project containers

	__bindHandlers: ->
		# bind swipe handler (click and touch)
		# bind keyboard hotkeys (arrows)

	__appendProjectSlides: ->
		slides = []
		console.log @projects
		# for project, idx in @projects
		# 	@slides.push new Project modelOptions: project.