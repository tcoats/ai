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
], (inject, p2) ->
	class Physics
		constructor: ->
			@maxvelocity = 100
			@defaultsteeringforce = 1200
			@entities = []
			@world = new p2.World gravity: [0, 0]
			
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
				entity.b.position[0] = width + 10 if entity.b.position[0] < -10
				entity.b.position[0] = -10 if entity.b.position[0] > width + 10
				entity.b.position[1] = height + 10 if entity.b.position[1] < -10
				entity.b.position[1] = -10 if entity.b.position[1] > height + 10
		
		register: (entity, n, p, v) =>
			@[n] entity, p, v if @[n]?
		
		boid: (entity, p, v) =>
			body = new p2.Body mass: 1, position: p, velocity: v
			body.damping = 0
			shape = new p2.Circle 8
			body.addShape shape
			@world.addBody body
			@entities.push entity.phys =
				b: body
				s: shape
				e: -> entity
		
		unit: (entity, p, v) =>
			body = new p2.Body mass: 1, position: p, velocity: v
			body.damping = 0
			shape = new p2.Circle 8
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