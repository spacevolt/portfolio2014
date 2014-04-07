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
		winH = $(window).height()
		contentH = winH
		@$('#Page-Container').css 'height', contentH