Controller = require 'base/controller'

module.exports = class GalleryController extends Controller
	autoRender: false
	template: require './templates/gallery'