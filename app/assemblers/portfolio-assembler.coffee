Assembler = require 'base/assembler'

Header = require 'module/base/header/header-controller'

module.exports = class PortfoliosAssembler extends Assembler
	beforeAction: ->
		super
		@reuse 'header', Header, region: 'header'

	index: ->
		#...