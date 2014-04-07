Controller = require 'base/controller'

module.exports = class DetailController extends Controller
	autoRender: false
	template: require './templates/detail'