define ['inject', 'p2'], (inject, p2) ->
	inject.bind 'line up', (entity, scale) ->
		entity.target = null
		distances = []
		
		inject.one('each by distance') entity.phys.b.position, 50, (d, e) =>
			return if e is entity or !e.ai?
			distances.push
				d: d
				e: e
		
		return if distances.length is 0
		
		distances.sort (a, b) => a.d - b.d
		
		if distances.length is 1
			entity.target = p2.vec2.clone distances[0].e.phys.b.position
		else
			entity.target = inject.one('calculate perpendicular') distances[0].e.phys.b.position, distances[1].e.phys.b.position,  entity.phys.b.position
		
		mag = [0, 0]
		p2.vec2.sub mag, entity.target, entity.phys.b.position
		inject.one('scale to max velocity') mag
		force = inject.one('calculate steering') entity.phys.b.velocity, mag
		p2.vec2.scale force, force, scale
		inject.one('apply force') entity, force