Controller = require 'base/controller'

module.exports = class HeaderController extends Controller
	autoRender: true
	className: 'hud'
	template: require './templates/header'