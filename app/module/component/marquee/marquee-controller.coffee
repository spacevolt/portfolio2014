Controller = require 'base/controller'

module.exports = class MarqueeController extends Controller
	autoRender: false
	className: 'marquee-container'
	template: require './templates/marquee'

	attached: ->
		@projects = @model.get 'projects'
		console.log 'MarqueeController: ', @projects