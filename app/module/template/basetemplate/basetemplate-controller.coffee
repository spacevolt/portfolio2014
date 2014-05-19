Controller = require 'base/controller'

module.exports = class BasetemplateController extends Controller
	autoRender: false
	template: require './templates/basetemplate'