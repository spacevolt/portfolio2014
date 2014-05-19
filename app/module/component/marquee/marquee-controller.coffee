Controller = require 'base/controller'

module.exports = class MarqueeController extends Controller
	autoRender: false
	className: 'marquee'
	template: require './templates/marquee'