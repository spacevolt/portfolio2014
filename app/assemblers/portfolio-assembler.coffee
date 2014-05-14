Assembler = require 'base/assembler'

Header = require 'module/base/header/header-controller'
Portfolio = require 'module/page/portfolio/portfolio-controller'

portfolioData = require 'util/data'
ev = require 'util/events'

module.exports = class PortfoliosAssembler extends Assembler
	# beforeAction: ->
	# 	super
	# 	@reuse 'header', Header, region: 'header'

	index: (options)->
		@options = options
		# if options.portfolio is about, call up the about page
		# if options.portfolio is blank, pass in blank index
		if portfolioData.ready
			@__instantiatePortfolio()
		else
			@subscribeEvent ev.mediator.data.ready, @__loadPage
	__loadPage: ->
		@__instantiateHeader()
		@__instantiatePortfolio()
	__instantiateHeader: ->
		@reuse 'header', Header, {region: 'header', model: portfolioData.portfolio}
	__instantiatePortfolio: ->
		@carousel = new Portfolio
			region: 'main'
			portfolio: portfolioData.portfolio
			projects: portfolioData.projects
			currentIndex: @__getCurrentSlideIndex()
		@publishEvent ev.mediator.assembler.carouselready, @

	__getCurrentSlideIndex: ->
		slideIndex = 0
		return slideIndex if _.isNull @options.project

		slug = @options.project
		for project, idx in portfolioData.portfolio.projects
			slideIndex = idx if project.slug is slug
		slideIndex