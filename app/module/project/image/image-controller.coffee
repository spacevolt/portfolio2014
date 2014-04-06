Controller = require 'base/controller'

module.exports = class ImageController extends Controller
	autoRender: false
	template: require './templates/image'