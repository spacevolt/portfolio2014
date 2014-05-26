Controller = require 'base/controller'

module.exports = class ItemController extends Controller
	autoRender: true
	className: 'marquee-item'
	template: require './templates/item'

	resize: ->
		# ...