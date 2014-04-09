Controller = require 'base/controller'

module.exports = class PortfolioController extends Controller
	autoRender: true
	className: 'portfolio-carousel'
	template: require './templates/portfolio'

	attached: ->
		console.log 'PortfolioController Attached'

	resize: ->
		# resize carousel striper
		# resize project containers
		# reposition project containers

	bindHandlers: ->
		# bind swipe handler (click and touch)
		# bind keyboard hotkeys (arrows)