SingletonWrapper = class DataManagerSingleton
	getInstance: ->
		window.pgomez = window.pgomez || {}
		window.pgomez.data = window.pgomez.data || new DataManager

DataManager = class DataUtil
	portfolio: null
	loader: null
	dataTimeLimit: 3000
	ready: null

	constructor: ->
		@__initialize()
	fetchData: ->
		@__initialize()

	__initialize: ->
		@project = null
		@loader = null
		@ready = null
		@__retrievePortfolio()

	__retrievePortfolio: (url)->
		url = url || "data/pgomez.json"
		#
	__retrievedPortfolio: (data)->
		# Data receiver for portfolio
		@portfolio = data


	__loaderInit: (options)->
		# receiver is handler which receives AJAXed data
		# success is handler fired when all datakeys have returned data
		# data is an array of data objects and where to get them
		@loader = {} if !@loader
		defaultOptions =
			context: @
			success: null
			receiver: null
			data: [{
				key: undefined
				url: undefined
				complete: false
				}]
		@loader = _.merge @loader, defaultOptions

dataManager = new SingletonWrapper
module.exports = dataManager.getInstance()