Controller = require 'base/controller'

module.exports = class ProjectController extends Controller
	autoRender: true
	className: 'project'
	template: require './templates/project'