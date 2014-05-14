Controller = require 'base/controller'

resizer = require 'util/resizer'
ev = require 'util/events'

module.exports = class ProjectController extends Controller
	autoRender: true
	className: 'project-slide'
	template: require './templates/project'

	attached: ->
		@slideClass = 'slide'+@model.get 'index'
		@$el.addClass @slideClass
		@__bindProjectButton()

	__bindProjectButton: ->
		@$('button').on ev.all.click, @__loadProjectTemplates
		@$('button').on ev.mouse.down+' '+ev.mouse.up+' '+ev.mouse.move, @__stopPropagation

	__stopPropagation: (e)->
		e.preventDefault()
		e.stopPropagation()
	__loadProjectTemplates: ->
		console.log 'LOAD PROJECT'

	debounceDuration: 50
	resize: ->
		@__staticTransitions()
		@resizeBackgroundImage()
		@positionSlideCopy()
		@__animateTransitions()
	resizeBackgroundImage: ->
		resizer.coverImage @$('.project-bgimg'), @$('.project-feature')
	positionSlideCopy: ->
		resizer.centerEl @$('.project-info'), @$('.project-feature')

	__animateTransitions: ->
		setTimeout =>
			@$('.project-info').addClass 'primed'
		, 200
	__staticTransitions: ->
		@$('.project-info').removeClass 'primed'