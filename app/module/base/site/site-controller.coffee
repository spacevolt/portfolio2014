Controller = require 'base/controller'

module.exports = class SiteController extends Controller
	autoRender: true
	container: 'body'
	id: 'Site-Container'
	regions:
		header: 'nav.header'
		main: '#Page-Container .page-wrapper'
		footer: 'footer'
	template: require './templates/site'

	resize: ->
		minH = 320
		winH = $(window).height()
		contentH = if winH > minH then winH else minH
		@$el.css 'height', contentH