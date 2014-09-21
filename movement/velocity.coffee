define ['inject', 'p2'], (inject, p2) ->
	maxvelocity = 100
	
	inject.bind 'max velocity', maxvelocity
	
	inject.bind 'scale to max velocity', (velocity) =>
		p2.vec2.normalize velocity, velocity
		p2.vec2.scale velocity, velocity, maxvelocity
	
	inject.bind 'limit to max velocity', (velocity) =>
		len = p2.vec2.len velocity
		len = Math.min len, maxvelocity
		p2.vec2.normalize velocity, velocity
		p2.vec2.scale velocity, velocity, len