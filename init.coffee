# # AI Testbed
define 'plugins', [
	'statistics'
	'ai'
	'physics'
	'display'
]

define 'game', ['inject', 'plugins'], (inject) ->
	createunit = (u) ->
		inject.one('register ai') u, 'brains/unit'
		inject.one('register statistics') u
		inject.one('register physics') u, 'unit',
			[random(width), random(height)],
			[0, 0]
		inject.one('register display') u, 'unit'
		
	createunit {} for _ in [0..49]
	chosenone = neo: yes
	createunit chosenone

window.setup = ->
	createCanvas windowWidth, windowHeight
	requirejs.config
		# cache busting
		urlArgs: 'v=' + (new Date()).getTime()
		paths: p2: 'lib/p2.min'
	requirejs ['inject', 'game'], (inject) ->
		setup() for setup in inject.many 'setup'
		render = yes
		window.draw = ->
			return if !render
			step() for step in inject.many 'step'
		window.mousePressed = ->
			render = !render