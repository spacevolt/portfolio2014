#***[ARRAY REMOVE ELEMENT]
#*************************
Array.prototype.remove = (from, to)->
	rest = @slice((to or from) + 1 or @length)
	@length = if from < 0 then @length + from else from
	@push.apply @, rest

module.exports = class DataLoader
	loader: null
	loadCount: 0
	loadInProgress: false

	load: (options)->
		# receiver is handler which receives AJAXed data
		# complete is handler fired when all datakeys have returned data
		# data is an array of data objects and where to get them
		@loader = [] unless @loader
		defaultOptions =
			context: @
			receiver: null
			complete: null
			data: [{
				url: undefined
				dataType: 'json'
				}]
		options = _.merge defaultOptions, options
		@loader.push options
		@__loadAllDataInOrder() if !@loadInProgress

	__loadAllDataInOrder: (data, counter)->
		return if @loadInProgress
		@__loadNext()
	__loadNext: ->
		loader = @loader[0]
		@loadInProgress = true
		count = @loadCount
		if !loader.data[count].url
			throw new Error 'Data Loader: data is missing URL (index: '+count+')'
		$.ajax
			type: 'GET'
			url: loader.data[count].url
			dataType: loader.data[count].dataType
			success: (data)=>
				@__dataLoaded data, count
	__dataLoaded: (data, counter)->
		loader = @loader[0]
		@loadCount++
		if @loadCount is loader.data.length
			loader.complete.call loader.context, data
			if @loader.length <= 1
				@__allRequestsCompleted()
			else
				@__requestCompleted()
		else
			loader.receiver.call loader.context, data
			@loadInProgress = false
			@__loadNext()

	__requestCompleted: ->
		@loader.remove 0
		@loadInProgress = false
		@loadCount = 0
		@__loadAllDataInOrder()
	__allRequestsCompleted: ->
		@loader = null
		@loadCount = 0
		@loadInProgress = false