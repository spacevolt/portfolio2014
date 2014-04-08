Controller = require 'base/controller'

module.exports = class ProjectController extends Controller
	autoRender: false
	template: require './templates/project'