Controller = require 'base/controller'

module.exports = class MenuController extends Controller
	autoRender: true
	className: 'gmenu'
	template: require './templates/menu'