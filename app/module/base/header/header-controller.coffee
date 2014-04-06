Controller = require 'base/controller'

module.exports = class HeaderController extends Controller
	autoRender: false
	template: require './templates/header'