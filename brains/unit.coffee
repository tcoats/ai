define ['inject', 'p2'], (inject, p2) ->
	class Unit
		constructor: (entity, n) ->
			@e = entity
			@n = n
		
		step: =>
			direction = [random(2) - 1, random(2) - 1]
			p2.vec2.scale direction, direction, 1000
			inject.one('apply force') @e, direction
			inject.one('separate') @e
			inject.one('align') @e
			inject.one('cohere') @e