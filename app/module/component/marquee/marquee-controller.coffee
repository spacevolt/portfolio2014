Controller = require 'base/controller'

module.exports = class MarqueeController extends Controller
	autoRender: false
	template: require './templates/marquee'