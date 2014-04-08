Assembler = require 'base/assembler'

Header = require 'module/base/header/header-controller'
Menu = require 'module/base/menu/menu-controller'
Portfolio = require 'module/page/portfolio/portfolio-controller'

module.exports = class PortfoliosAssembler extends Assembler
	beforeAction: ->
		super
		@reuse 'header', Header, region: 'header'
		@reuse 'menu', Menu, region: 'footer'

	index: ->
		@carousel = new Portfolio region: 'main'