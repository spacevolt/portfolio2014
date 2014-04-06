Assembler = require 'base/assembler'

Home = require 'module/page/home/home-controller'

module.exports = class HomeAssembler extends Assembler

	beforeAction: ->
		super

	index: (options)->
		@Page = new Home region: 'main'