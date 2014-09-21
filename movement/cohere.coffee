define ['inject', 'p2'], (inject, p2) ->
	inject.bind 'cohere', (entity, scale) ->
		averageposition = [0, 0]
		count = 0
		inject.one('each by distance') entity.phys.b.position, 100, (d, e) ->
			return if e is entity or !e.ai?
			p2.vec2.add averageposition, averageposition, e.phys.b.position
			count++
		
		inject.one('abs stat') entity,
			iscommunity: count > 0
		iscommunity = count > 0
		
		return if p2.vec2.len(averageposition) is 0
		p2.vec2.scale averageposition, averageposition, 1 / count
		
		targetvelocity = inject.one('calculate seeking') entity.phys.b.position, averageposition
		force = inject.one('calculate steering') entity.phys.b.velocity, targetvelocity
		p2.vec2.scale force, force, scale
		inject.one('apply force') entity, force