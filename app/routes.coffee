# Application routes.
module.exports = (match) ->
	match '', 'portfolio#index'
	match '!/:project', 'portfolio#index'