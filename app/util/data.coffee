Loader = require 'util/dataloader'
loader = new Loader

SingletonWrapper = class DataManagerSingleton
	getInstance: ->
		window.pgomez = window.pgomez || {}
		window.pgomez.data = window.pgomez.data || new DataManager

DataManager = class DataUtil
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
		url = @portfolioURL || "data/pgomez.json"
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
	__getProjectUrls: ->
		urls = []
		for project in @portfolio.projects
			urls.push project.jsonUrl
		urls
		
dataManager = new SingletonWrapper
module.exports = dataManager.getInstance()