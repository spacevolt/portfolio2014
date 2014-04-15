# Application routes.
module.exports = (match) ->
	match '', 'portfolio#index', params: { project: null }
	match '!/:project', 'portfolio#index'