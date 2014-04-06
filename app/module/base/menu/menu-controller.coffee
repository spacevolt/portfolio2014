Controller = require 'base/controller'

module.exports = class MenuController extends Controller
	autoRender: false
	template: require './templates/menu'