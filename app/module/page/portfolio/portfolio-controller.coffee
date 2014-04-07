Controller = require 'base/controller'

module.exports = class PortfolioController extends Controller
	autoRender: true
	template: require './templates/portfolio'