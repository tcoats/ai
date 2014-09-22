define [
	'inject'
	'p2'
	'movement/rotate'
	'movement/directions'
	'movement/force'
	'movement/steer'
	'movement/velocity'
	'movement/separate'
	'movement/cohere'
	'movement/align'
	'movement/lineup'
	'movement/squaregroup'
], (inject, p2) ->
	class Physics
		constructor: ->
			@entities = []
			@world = new p2.World gravity: [0, 0]
			@maxvelocity = inject.one 'max velocity'
			@offsetwidth = 5
			
			inject.bind 'step', @step
			inject.bind 'register physics', @register
			inject.bind 'each by distance', @eachbydistance
		
		# Integrate
		step: =>
			@world.step 1 / 60
			for entity in @entities
				length = p2.vec2.len entity.b.velocity
				if length > @maxvelocity
					p2.vec2.normalize entity.b.velocity, entity.b.velocity
					p2.vec2.scale entity.b.velocity, entity.b.velocity, @maxvelocity
				entity.b.position[0] = width + @offsetwidth if entity.b.position[0] < -@offsetwidth
				entity.b.position[0] = -@offsetwidth if entity.b.position[0] > width + @offsetwidth
				entity.b.position[1] = height + @offsetwidth if entity.b.position[1] < -@offsetwidth
				entity.b.position[1] = -@offsetwidth if entity.b.position[1] > height + @offsetwidth
		
		register: (entity, n, p, v) =>
			@[n] entity, p, v if @[n]?
		
		person: (entity, p, v) =>
			body = new p2.Body mass: 1, position: p, velocity: v
			body.damping = 0
			shape = new p2.Circle 6
			body.addShape shape
			@world.addBody body
			@entities.push entity.phys =
				b: body
				s: shape
				e: -> entity
		
		eachbydistance: (p, r, cb) =>
			for entity in @entities
				distance = p2.vec2.dist p, entity.b.position
				continue if distance > r
				cb distance, entity.e()
			
	new Physics()