requirejs.config paths: p2: 'lib/p2.min'

# # AI Testbed
define 'plugins', [
	'statistics'
	'ai'
	'physics'
	'display'
]

define 'game', ['inject', 'plugins'], (inject) ->
	ai = inject.one 'register ai'
	stats = inject.one 'register statistics'
	phys = inject.one 'register physics'
	display = inject.one 'register display'
	
	createunit = (u, brain) ->
		motif = brain
		motif = 'neo' if u.neo?
		ai u, "brains/#{brain}"
		stats u
		phys u, 'person',
			[random(width), random(height)],
			[0, 0]
		display u, motif
	createunit {}, 'unit' for _ in [0..49]
	
	# Create neo for testing
	window.neo = neo: yes
	createunit window.neo, 'unit'

window.setup = ->
	createCanvas windowWidth, windowHeight
	requirejs ['inject', 'game'], (inject) ->
		setup() for setup in inject.many 'setup'
		render = yes
		
		inject.bind 'target', null
		
		window.draw = ->
			return if !render
			step() for step in inject.many 'step'
		
		window.touchStarted = ->
			target = inject.one 'target'
			
			if target?
				inject.clear 'target'
				inject.bind 'target', null
			else
				setTimeout ->
					inject.clear 'target'
					inject.bind 'target', [touchX, touchY]
				, 0
		
		window.touchMoved = ->
			inject.clear 'target'
			inject.bind 'target', [touchX, touchY]
		
		window.touchEnded = ->
			target = inject.one 'target'
			if target?
				inject.clear 'target'
				inject.bind 'target', [touchX, touchY]
		