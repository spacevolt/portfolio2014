module.exports = class Loader
	loader: null
	loadCount: 0
	loadInProgress: false

	load: (options)->
		@loader = null
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
				completed: false
				}]
		@loader.push _.merge {}, defaultOptions, options
		currLoader = @loader[@loader.length-1]
		@__loadAllDataInOrder()

	__loadAllDataInOrder: (data, counter)->
		loader = @loader[0]

		if typeof counter is 'number'
			@loadCount++
			if @loadCount is loader.data.length
				loader.complete.call loader.context, data
				if @loader.length <= 1
					@loader = null
					@loadCount = 0
					return undefined
				else
					#remove the first entry of @loader
					#recurse this function
			else
				loader.receiver.call loader.context, data
				@loadInProgress = false

		return if @loadInProgress

		@loadInProgress = true
		count = @loadCount
		if !loader.data[count].url
			throw new Error 'Data Loader: data is missing URL (index: '+count+')'
		$.ajax
			type: 'GET'
			url: loader.data[count].url
			dataType: loader.data[count].dataType
			success: (data)=>
				@__loadAllDataInOrder data, count