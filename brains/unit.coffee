define ['inject', 'p2'], (inject, p2) ->
	class Unit
		constructor: (entity, n) ->
			@e = entity
			@n = n
		
		step: =>
			target = inject.one 'target'
			return if !target?
			
			@forcetarget target
		
		forcetarget: (target) =>
			direction = [0, 0]
			p2.vec2.sub direction, target, @e.phys.b.position
			inject.one('scale to max velocity') direction
			inject.one('apply force') @e, direction
		
		seektarget: (target) =>
			force = inject.one('calculate seeking') @e.phys.b.position, target
			inject.one('apply force') @e, force
		
		fuzzy: =>
			direction = [random(2) - 1, random(2) - 1]
			p2.vec2.scale direction, direction, 1000
			inject.one('apply force') @e, direction
			#inject.one('separate') @e, 2.0
			inject.one('align') @e, 0.5
			inject.one('cohere') @e, 1.0
		
		boid: =>
			inject.one('separate') @e, 2.0
			inject.one('align') @e, 0.5
			inject.one('cohere') @e, 1.0
		
		lineup: =>
			inject.one('separate') @e, 0.6
			inject.one('line up') @e, 0.5
		
		square: =>
			inject.one('separate') @e, 2
			inject.one('align') @e, 0.4
			inject.one('square group') @e, 0.5
			inject.one('cohere') @e, 0.1