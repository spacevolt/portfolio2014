Controller = require 'base/controller'

resizer = require 'util/resizer'

module.exports = class ProjectController extends Controller
	autoRender: true
	className: 'project-slide'
	template: require './templates/project'

	attached: ->
		@slideClass = 'slide'+@model.get 'index'
		@$el.addClass @slideClass
		# console.log @model.attributes

	debounceDuration: 50
	resize: ->
		@resizeBackgroundImage()
		@positionSlideCopy()
	resizeBackgroundImage: ->
		resizer.coverImage @$('.project-bgimg'), @$('.project-feature')
	positionSlideCopy: ->
		resizer.centerEl @$('.project-info'), @$('.project-feature')