Controller = require 'base/controller'

module.exports = class PortfolioController extends Controller
	autoRender: true
	className: 'portfolio-carousel'
	template: require './templates/portfolio'