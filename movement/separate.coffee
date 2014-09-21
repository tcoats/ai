define ['inject', 'p2'], (inject, p2) ->
	inject.bind 'separate', (entity) ->
		averagerepulsion = [0, 0]
		inject.one('each by distance') entity.phys.b.position, 25, (d, e) ->
			return if e is entity or !e.ai?
			diff = [0, 0]
			# proportional to distance from other?
			p2.vec2.sub diff, entity.phys.b.position, e.phys.b.position
			p2.vec2.normalize diff, diff
			p2.vec2.add averagerepulsion, averagerepulsion, diff
		
		istouched = p2.vec2.len(averagerepulsion) isnt 0
		inject.one('abs stat') entity, istouched: istouched
		return if !istouched
		
		inject.one('scale to max velocity') averagerepulsion
		force = inject.one('calculate steering') entity.phys.b.velocity, averagerepulsion
		p2.vec2.scale force, force, 2
		inject.one('apply force') entity, force