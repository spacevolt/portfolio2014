Assembler = require 'base/assembler'

Header = require 'module/base/header/header-controller'
Marquee = require 'module/component/marquee/marquee-controller'
Portfolio = require 'module/page/portfolio/portfolio-controller'

portfolioData = require 'util/data'
ev = require 'util/events'

module.exports = class PortfoliosAssembler extends Assembler

	index: (options)->
		@options = options
		# if options.portfolio is about, call up the about page
		# if options.portfolio is blank, pass in blank index
		if portfolioData.ready
			@__loadPage()
		else
			@subscribeEvent ev.mediator.data.ready, @__loadPage
	__loadPage: ->
		@__instantiatePortfolio()
		@__instantiateComponents()
	__instantiateComponents: ->
		@reuse 'marquee', Marquee, {container: '.page-wrapper', model: portfolioData.portfolio}
	__instantiatePortfolio: ->
		@carousel = new Portfolio
			region: 'main'
			portfolio: portfolioData.portfolio
			projects: portfolioData.projects
			currentIndex: @__getCurrentSlideIndex()
			onAboutPage: @options.project is portfolioData.portfolio.about.slug
		@publishEvent ev.mediator.assembler.carouselready, @

	__getCurrentSlideIndex: ->
		slideIndex = 0
		slug = @options.project
		indexIsAbout = slug is portfolioData.portfolio.about.slug

		return slideIndex if _.isNull @options.project or indexIsAbout

		for project, idx in portfolioData.portfolio.projects
			slideIndex = idx if project.slug is slug
		slideIndex