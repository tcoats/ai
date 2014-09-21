define ['inject', 'p2'], (inject, p2) ->
	inject.bind 'square group', (entity, scale) ->
		entity.target = null
		entity.targets = null
		
		# get a local view of the battlefield
		distances = []
		inject.one('each by distance') entity.phys.b.position, 60, (d, e) ->
			return if e is entity or !e.ai?
			distances.push
				d: d
				e: e
		
		# no one around, probably should 'search'
		return if distances.length is 0
		
		# sort by closeness
		distances.sort (a, b) -> a.d - b.d
		targets = []
		
		first = distances[0]
		
		# one comrade, move into position
		if distances.length is 1
			target = [0, 0]
			p2.vec2.sub target, entity.phys.b.position, first.e.phys.b.position
			p2.vec2.normalize target, target
			p2.vec2.scale target, target, 32
			p2.vec2.add target, target, first.e.phys.b.position
			targets.push target
		
		# more than one comrade, form a phalanx
		else
			next =
				d: 120
				e: null
			for d in distances
				continue if d.e is first.e
				dist = p2.vec2.dist d.e.phys.b.position, first.e.phys.b.position
				if dist < next.d
					next.d = dist
					next.e = d.e
			
			target = [0, 0]
			p2.vec2.sub target, first.e.phys.b.position, next.e.phys.b.position
			p2.vec2.normalize target, target
			p2.vec2.scale target, target, 32
			
			target1 = [0, 0]
			p2.vec2.add target1, first.e.phys.b.position, target
			target2 = [0, 0]
			p2.vec2.sub target2, first.e.phys.b.position, target
			rotate = inject.one('anticlockwise') target
			target3 = [0, 0]
			p2.vec2.add target3, first.e.phys.b.position, rotate
			target4 = [0, 0]
			p2.vec2.sub target4, first.e.phys.b.position, rotate
			targets.push target1
			targets.push target2
			targets.push target3
			targets.push target4
		
		# discount any target that is too close to a comrade
		targets = targets.filter (t) ->
			for d in distances
				dist = p2.vec2.dist t, d.e.phys.b.position
				if dist <= 24
					return no
			yes
			
		targets = targets.map (t) ->
			d: p2.vec2.dist t, entity.phys.b.position
			t: t
		targets.sort (a, b) -> a.d - b.d
		
		entity.targets = targets
		
		# no space - panic!
		return if targets.length is 0
		
		entity.target = targets[0].t
		
		mag = [0, 0]
		p2.vec2.sub mag, entity.target, entity.phys.b.position
		inject.one('limit to max velocity') mag
		force = inject.one('calculate steering') entity.phys.b.velocity, mag
		p2.vec2.scale force, force, scale
		inject.one('apply force') entity, force