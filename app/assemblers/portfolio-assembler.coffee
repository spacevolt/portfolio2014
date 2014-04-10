Assembler = require 'base/assembler'

Header = require 'module/base/header/header-controller'
Menu = require 'module/base/menu/menu-controller'
Portfolio = require 'module/page/portfolio/portfolio-controller'

portfolioData = require 'util/data'

module.exports = class PortfoliosAssembler extends Assembler
	beforeAction: ->
		super
		@reuse 'header', Header, region: 'header'
		@reuse 'menu', Menu, region: 'footer'

	index: (options)->
		# if options.portfolio is about, call up the about page
		# if options.portfolio is blank, pass in blank index
		@carousel = new Portfolio
			region: 'main'