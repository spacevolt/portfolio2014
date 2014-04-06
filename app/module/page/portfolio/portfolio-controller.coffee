Controller = require 'base/controller'

module.exports = class PortfolioController extends Controller
	autoRender: false
	template: require './templates/portfolio'