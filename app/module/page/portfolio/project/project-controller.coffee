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

	resize: ->
		$keyArt = @$('.project-keyart')
		$keyArtWrap = @$('.keyart-wrap')
		resizer.fitToContainer $keyArt, $keyArtWrap