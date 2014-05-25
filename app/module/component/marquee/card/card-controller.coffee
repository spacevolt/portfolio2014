Controller = require 'base/controller'

module.exports = class CardController extends Controller
	autoRender: false
	template: require './templates/card'