ev = require 'util/events'
Loader = require 'util/dataloader'
loader = new Loader

SingletonWrapper = class DataManagerSingleton
	getInstance: ->
		window.carousel = window.carousel || {}
		window.carousel.data = window.carousel.data || new DataManager

DataManager = class DataUtil
	_.extend @prototype, Chaplin.EventBroker
	portfolio: null
	projects: null
	numProjects: null
	ready: null
	portfolioURL: null

	constructor: ->
		@__initialize()
	fetchData: ->
		@__initialize()

	__initialize: ->
		@portfolio = null
		@projects = null
		@ready = null
		@__retrievePortfolio()

	__retrievePortfolio: ->
		url = @portfolioURL || "data/carousel.json"
		options =
			context: @
			receiver: @__retrievedPortfolio
			complete: @__retrievedPortfolio
			data: [{
				url: url
				}]
		loader.load options

	__retrievedPortfolio: (data)->
		# Data receiver for portfolio
		@portfolio = data
		@numProjects = @portfolio.projects.length
		@__retrieveProjects()

	__retrieveProjects: ->
		@projects = []
		projectUrls = @__getProjectUrls()
		data = []
		for url in projectUrls
			data.push {url: url}
		options =
			context: @
			receiver: @__retrievedProject
			complete: @__retrievedProject
			data: data
		loader.load options
	__retrievedProject: (data)->
		@projects.push data
		if @projects.length is @portfolio.projects.length
			@ready = true
			@publishEvent ev.mediator.data.ready
	__getProjectUrls: ->
		urls = []
		for project in @portfolio.projects
			urls.push project.jsonUrl
		urls
		
dataManager = new SingletonWrapper
module.exports = dataManager.getInstance()