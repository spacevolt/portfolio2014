Loader = require 'util/dataloader'
loader = new Loader

SingletonWrapper = class DataManagerSingleton
	getInstance: ->
		window.pgomez = window.pgomez || {}
		window.pgomez.data = window.pgomez.data || new DataManager

DataManager = class DataUtil
	portfolio: null
	ready: null
	portfolioURL: null

	constructor: ->
		@__initialize()
	fetchData: ->
		@__initialize()

	__initialize: ->
		@project = null
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
		console.log '1', @
		
dataManager = new SingletonWrapper
module.exports = dataManager.getInstance()