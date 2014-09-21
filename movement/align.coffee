define ['inject', 'p2'], (inject, p2) ->
	inject.bind 'align', (entity) ->
		averagedirection = [0, 0]
		count = 0
		inject.one('each by distance') entity.phys.b.position, 50, (d, e) ->
			return if e is entity or !e.ai?
			p2.vec2.add averagedirection, averagedirection, e.phys.b.velocity
			count++
		return if p2.vec2.len(averagedirection) is 0
		
		inject.one('scale to max velocity') averagedirection
		force = inject.one('calculate steering') entity.phys.b.velocity, averagedirection
		p2.vec2.scale force, force, 0.5
		inject.one('apply force') entity, force