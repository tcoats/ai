define ['inject', 'p2'], (inject, p2) ->
	inject.bind 'calculate perpendicular', (from, to, point) =>
		unit = [0, 0]
		p2.vec2.sub unit, to, from
		p2.vec2.normalize unit, unit
		calc = [0, 0]
		p2.vec2.sub calc, point, from
		lambda = p2.vec2.dot unit, calc
		p2.vec2.scale calc, unit, lambda
		p2.vec2.add calc, from, calc
		calc