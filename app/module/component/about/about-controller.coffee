Controller = require 'base/controller'

module.exports = class AboutController extends Controller
	autoRender: true
	className: 'about-page'
	template: require './templates/about'