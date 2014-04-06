Controller = require 'base/controller'

module.exports = class AboutController extends Controller
	autoRender: false
	template: require './templates/about'